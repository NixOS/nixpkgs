{
  stdenv,
  curl,
  legendsviewer-next,
}:
stdenv.mkDerivation rec {
  pname = "${legendsviewer-next.pname}-test";
  version = legendsviewer-next.version;

  nativeBuildInputs = [
    curl
    legendsviewer-next
  ];

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    timeout 10 LegendsViewer &
    sleep 2

    # Static server is up
    curl -f http://localhost:8081 | grep "<!doctype html>"

    # Version matches expected
    curl -f http://localhost:5054/api/version | grep ${version}

    echo > $out

    runHook postBuild
  '';

  dontCheck = true;
  dontInstall = true;
  dontFixup = true;
}
