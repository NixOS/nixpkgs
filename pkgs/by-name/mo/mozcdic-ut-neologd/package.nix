{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-neologd";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-neologd";
    rev = "b0de4b90d7ddc3b837b40dc6974d6467daedc491";
    hash = "sha256-mS6GRvlAIyV0maZ+jbGUgZDPoS5OwnRGmJDTYiSw0FY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-neologd.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT NEologd Dictionary is a dictionary converted from mecab-ipadic-NEologd for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-neologd";
    license = with lib.licenses;[ asl20 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
