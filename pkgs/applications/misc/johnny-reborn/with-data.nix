{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchzip
, johnny-reborn-engine
, makeWrapper
}:

let
  sounds = fetchFromGitHub {
    owner = "nivs1978";
    repo = "Johnny-Castaway-Open-Source";
    rev = "be6afefd43a3334acc66fc9d777c162c8bfb9558";
    hash = "sha256-rtZVCn4KbEBVwaSQ4HZhMoDEI5Q9IPj9SZywgAx0MPY=";
  };

  resources = fetchzip {
    name = "scrantic-source";
    url = "https://archive.org/download/johnny-castaway-screensaver/scrantic-run.zip";
    hash = "sha256-Q9chCYReOQEmkTyIkYo+D+OXYUqxPNOOEEmiFh8yaw4=";
    stripRoot = false;
  };
in

stdenvNoCC.mkDerivation {
  pname = "johnny-reborn";
  inherit (johnny-reborn-engine) version;

  srcs = [ sounds resources ];

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = sounds.name;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jc_reborn/data
    cp -t $out/share/jc_reborn/data/ \
      ../scrantic-source/RESOURCE.* \
      JCOS/Resources/sound*.wav

    makeWrapper \
      ${johnny-reborn-engine}/bin/jc_reborn \
      $out/bin/jc_reborn \
      --chdir $out/share/jc_reborn

    runHook postInstall
  '';

  meta = {
    description = "An open-source engine for the classic \"Johnny Castaway\" screensaver (ready to use, with resources)";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pedrohlc ];
    inherit (johnny-reborn-engine.meta) homepage platforms mainProgram;
  };
}
