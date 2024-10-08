{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-neologd";
  version = "0-unstable-2024-07-28";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-neologd";
    rev = "b7035b88db25ad1a933f05a33f193711c6c3b2db";
    hash = "sha256-JPTrWaDtdNs/Z0uLRwaS8Qc/l4/Y7NtwLanivyefXnk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-neologd.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT NEologd Dictionary is a dictionary converted from mecab-ipadic-NEologd for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-neologd";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
