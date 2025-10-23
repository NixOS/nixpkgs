{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libusb1,
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

  cargoHash = "sha256-JIm0XcgqXGPXlkQ1rhG5D38bQkQT9K44F71ZaCT2g8o=";

  cargoBuildFlags = [ "-p minidsp -p minidsp-daemon" ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libusb1 ];

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
