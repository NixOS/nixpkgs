{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  libopus,
  pkg-config,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "proxtx-clipper";
  version = "0-unstable-2024-02-17";

  src = fetchFromGitHub {
    owner = "Proxtx";
    repo = "clipper";
    rev = "782c1d72232b095fdd9d4b55e92e6afbcbc95575";
    hash = "sha256-prJRe5l4WaX2gAdZ6QCDb2VHqvIUUT1Fi5je3L0Rxj8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libopus ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Changing the name of the binary to proxtx-clipper
  postInstall = ''
    mv $out/bin/clipper $out/bin/proxtx-clipper
  '';

  meta = {
    description = "Clip your Discord VoiceChat. This Bot records the last 30 seconds and clips them";
    homepage = "https://github.com/Proxtx/clipper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vcele ];
    mainProgram = "proxtx-clipper";
    platforms = lib.platforms.all;
  };
}
