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

stdenvNoCC.mkDerivation {
  pname = "merge-ut-dictionaries";
  version = "0-unstable-2024-08-28";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "merge-ut-dictionaries";
    rev = "9cacaadfc4a199914726687ad6545bfd7152c001";
    hash = "sha256-AdcwXl+33pyN8Q95EDNwMps3ObCzys8nicege6yeRk8=";
  };

  nativeBuildInputs = [ python3 ];

  preConfigure =
    if (dictionaries == [ ]) then
      throw "merge-ut-dictionaries needs at least one dictionary"
    else
      ''
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

        for dir in ${builtins.toString dictionaries}; do
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
    description = "Mozc UT dictionaries are additional dictionaries for Mozc.";
    homepage = "https://github.com/utuhiro78/merge-ut-dictionaries";
    license = with lib.licenses; [
      cc-by-sa-40
      bsd3
      asl20
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides a dictionary
    hydraPlatforms = [ ];
  };
}
