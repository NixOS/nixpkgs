{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
, ruby
, jawiki-all-titles-in-ns0
, ibus-engines


, mozcdic-ut-jawiki
, mozcdic-ut-personal-names
, mozcdic-ut-place-names
, mozcdic-ut-sudachidict

, dictionaries ? [
    mozcdic-ut-jawiki
    mozcdic-ut-personal-names
    mozcdic-ut-place-names
    mozcdic-ut-sudachidict
  ]
}:

stdenvNoCC.mkDerivation {
  pname = "merge-ut-dictionaries";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "merge-ut-dictionaries";
    rev = "d44c83d4bfd947fb4369e6b0c2e6111e2f9bfaba";
    hash = "sha256-5iU44qQyYQ0e8qLsLUclrkzch6kvhbxkF/f2SrxNTHU=";
  };

  nativeBuildInputs = [ ruby ];

  preConfigure =
    if (dictionaries == []) then
      throw "merge-ut-dictionaries needs at least one dictionary"
    else ''
      cd src

      # needed for ruby to read files as utf-8
      export LANG=C.UTF-8
      export LANGUAGE=C.UTF-8
      export LC_ALL=C.UTF-8

      substituteInPlace make.sh \
        --replace-fail "git" "true #" \
        --replace-fail "mv mozcdic-ut" "#"

      substituteInPlace count_word_hits.rb \
        --replace-fail '`wget' "#" \
        --replace-fail "jawiki-latest-all-titles-in-ns0.gz" "${jawiki-all-titles-in-ns0}/jawiki-all-titles-in-ns0.gz"

      substituteInPlace remove_duplicate_ut_entries.rb \
        --replace-fail "URI.open(url)" 'File.new("${ibus-engines.mozc.src}/src/data/dictionary_oss/id.def","rt:utf-8")'

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT dictionaries are additional dictionaries for Mozc.";
    homepage = "https://github.com/utuhiro78/merge-ut-dictionaries";
    license = with lib.licenses;[ cc-by-sa-40 bsd3 asl20 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides a dictionary
    hydraPlatforms = [ ];
  };
}
