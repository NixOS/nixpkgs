{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libusb1,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minidsp";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "mrene";
    repo = "minidsp-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8bKP9/byVRKj1P1MP3ZVg8yw0WaNB0BcqarCti7B8CA=";
  };

  cargoHash = "sha256-JIm0XcgqXGPXlkQ1rhG5D38bQkQT9K44F71ZaCT2g8o=";

  cargoBuildFlags = [ "-p minidsp -p minidsp-daemon" ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libusb1 ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  meta = {
    description = "Control interface for some MiniDSP products";
    homepage = "https://github.com/mrene/minidsp-rs";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [
      lib.maintainers.adamcstephens
      lib.maintainers.mrene
    ];
  };
})
