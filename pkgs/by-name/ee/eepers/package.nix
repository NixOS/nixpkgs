{
  lib,
  stdenv,
  fetchFromGitHub,
  gnat,
  raylib,
  alsa-lib,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "eepers";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "eepers";
    tag = "v${version}";
    hash = "sha256-KG7ci327qlTtlN4yV54P8Q34ExFLJfTGMTZxN3RtZbc=";
  };

  postPatch = ''
    substituteInPlace eepers.adb \
      --replace-fail "assets/" "$out/assets/"
  '';

  buildInputs = [
    gnat
    raylib
  ];

  buildPhase = ''
    runHook preBuild

    gnatmake -f -O3 \
      -Wall \
      -Wextra \
      -gnat2012 \
      -o eepers-linux eepers.adb \
      -bargs \
      -largs -lraylib -lm \
      -pthread

    runHook postBuild
  '';

  postFixup = ''
    patchelf $out/bin/eepers \
      --add-needed libwayland-client.so \
      --add-needed libwayland-cursor.so \
      --add-needed libwayland-egl.so \
      --add-needed libasound.so \
      --add-rpath ${
        lib.makeLibraryPath [
          alsa-lib
          wayland
        ]
      }
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./eepers-linux $out/bin/eepers

    cp -r ./assets $out/

    runHook postInstall
  '';

  meta = {
    description = "Simple Turn-based Game";
    homepage = "https://github.com/tsoding/eepers";
    changelog = "https://github.com/tsoding/eepers/blob/${src.rev}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "eepers";
    platforms = lib.platforms.all;
  };
}
