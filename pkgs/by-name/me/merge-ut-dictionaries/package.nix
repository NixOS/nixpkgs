{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  python3,
  jawiki-all-titles-in-ns0,
  ibus-engines,

  mozcdic-ut-jawiki,
  mozcdic-ut-personal-names,
  mozcdic-ut-place-names,
  mozcdic-ut-sudachidict,

  dictionaries ? [
    mozcdic-ut-jawiki
    mozcdic-ut-personal-names
    mozcdic-ut-place-names
    mozcdic-ut-sudachidict
  ],
}:

assert lib.assertMsg (dictionaries != [ ]) "merge-ut-dictionaries needs at least one dictionary.";

stdenvNoCC.mkDerivation {
  pname = "merge-ut-dictionaries";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "merge-ut-dictionaries";
    rev = "4e08ad0bc0e493a35e9408edf963a3e77257b4cf";
    hash = "sha256-o+4a2FdMfKnCrZ7b+gbVwCBxs72M0QY4C8EnNyBZqXU=";
  };

  nativeBuildInputs = [ python3 ];

  preConfigure = ''
    cd src

    substituteInPlace make.sh \
      --replace-fail "git" "true #" \
      --replace-fail "mv mozcdic-ut" "#"

    substituteInPlace count_word_hits.py \
      --replace-fail 'subprocess.run' "#" \
      --replace-fail "jawiki-latest-all-titles-in-ns0.gz" "${jawiki-all-titles-in-ns0}/jawiki-all-titles-in-ns0.gz"

    substituteInPlace remove_duplicate_ut_entries.py \
      --replace-fail "url =" 'url = "${ibus-engines.mozc.src}/src/data/dictionary_oss/id.def"#' \
      --replace-fail "urllib.request.urlopen" "open" \
      --replace-fail "read().decode()" "read()"

    for dir in ${lib.concatStringsSep " " dictionaries}; do
      cp -v $dir/mozcdic-ut-*.txt.tar.bz2 .
    done
  '';

  buildPhase = ''
    runHook preBuild

    bash make.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out mozcdic-ut.txt
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT dictionaries are additional dictionaries for Mozc";
    homepage = "https://github.com/utuhiro78/merge-ut-dictionaries";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides a dictionary
    hydraPlatforms = [ ];
  };
}
