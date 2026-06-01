{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  libGL,
  libice,
  libsm,
  libx11,
  libxrandr,
  zlib,
  alsa-lib,
}:

stdenv.mkDerivation {
  pname = "rigsofrods-bin";
  version = "2022.12";

  src = fetchurl {
    url = "https://update.rigsofrods.org/rigs-of-rods-linux-2022-12.zip";
    hash = "sha256-jj152fd4YHlU6YCVCnN6DKRfmi5+ORpMQVDacy/TPeE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = [
    libGL
    libice
    libsm
    libx11
    libxrandr
    stdenv.cc.cc
    zlib
  ];

  runtimeDependencies = [
    alsa-lib
  ];

  noDumpEnvVars = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/rigsofrods
    cp -a . $out/share/rigsofrods
    for f in RoR RunRoR; do
      makeWrapper $out/share/rigsofrods/$f $out/bin/$f \
        --chdir $out/share/rigsofrods
    done

    runHook postInstall
  '';

  meta = {
    description = "Free/libre soft-body physics simulator mainly targeted at simulating vehicle physics";
    homepage = "https://www.rigsofrods.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      wegank
    ];
    platforms = [ "x86_64-linux" ];
  };
}
