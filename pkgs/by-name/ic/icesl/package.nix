{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  glfw,
  libGL,
  libGLU,
  openssl,
  zenity,
}:

stdenv.mkDerivation {
  pname = "iceSL";
  version = "20261109";

  src = fetchzip {
    url = "https://raw.githubusercontent.com/icesl/icesl-builds/039c92381bc407abef9ff4e17f9e9d8843f9c26b/icesl/linux/amd64/icesl_linux_amd64-20261109.zip";
    hash = "sha256-mGRhrbh/w5pp5EF0qwu92OX9zrZ7PHeg4mTkqi+Wyo8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    glfw
    libGL
    libGLU
    openssl
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icesl $out/bin
    cp -r . $out/share/icesl
    makeWrapper $out/share/icesl/bin/IceSL-slicer $out/bin/icesl \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath $out/share/icesl/bin
  '';

  meta = {
    description = "GPU-accelerated procedural modeler and slicer for 3D printing";
    homepage = "https://icesl.loria.fr/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.inria-icesl;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mgttlinger ];
    mainProgram = "icesl";
  };
}
