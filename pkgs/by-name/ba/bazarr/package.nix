{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
  python3,
  unar,
  ffmpeg,
  nixosTests,
}:

let
  runtimeProgDeps = [
    ffmpeg
    unar
  ];
in
stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "1.5.5";

  src = fetchzip {
    url = "https://github.com/morpheus65535/bazarr/releases/download/v${version}/bazarr.zip";
    hash = "sha256-YiR/hi+/vptjHxwBYsq/W3QdjT12+pv74AuU1ggM084=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    (python3.withPackages (ps: [
      ps.lxml
      ps.numpy
      ps.gevent
      ps.gevent-websocket
      ps.pillow
      ps.setuptools
      ps.psycopg2
      ps.webrtcvad
    ]))
  ]
  ++ runtimeProgDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/${pname}}
    cp -r * "$out/share/${pname}"

    # Add missing shebang and execute perms so that patchShebangs can do its
    # thing.
    sed -i "1i #!/usr/bin/env python3" "$out/share/${pname}/bazarr.py"
    chmod +x "$out/share/${pname}/bazarr.py"

    makeWrapper "$out/share/${pname}/bazarr.py" \
        "$out/bin/bazarr" \
        --suffix PATH : ${lib.makeBinPath runtimeProgDeps}

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    mainProgram = "bazarr";
    platforms = lib.platforms.all;
  };
}
