{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libusb1,
  AppKit,
  IOKit,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "minidsp";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mrene";
    repo = "minidsp-rs";
    rev = "v${version}";
    hash = "sha256-8bKP9/byVRKj1P1MP3ZVg8yw0WaNB0BcqarCti7B8CA=";
  };

  cargoHash = "sha256-GUrYEFpTo83lKuDyENaVN3VhnZ2Y/igtsbEY7kNa1os=";

  cargoBuildFlags = [ "-p minidsp -p minidsp-daemon" ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ libusb1 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      IOKit
    ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  meta = with lib; {
    description = "Control interface for some MiniDSP products";
    homepage = "https://github.com/mrene/minidsp-rs";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [
      maintainers.adamcstephens
      maintainers.mrene
    ];
  };
}
