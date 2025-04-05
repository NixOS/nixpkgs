{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  alsa-lib,
  udev,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bevy_skein";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "rust-adventure";
    repo = "skein";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pyO3/jMzlbjxv7XP9xtwR0KhXMmcQITzmBpDebP2d5Q=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-Q/6s4nLKrIfbJ+rJCsEiT5XnEp3mAS9K74L0iR4LYdU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      udev
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert glTF extras to Bevy Components using reflection";
    homepage = "https://github.com/rust-adventure/skein";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
  };
})
