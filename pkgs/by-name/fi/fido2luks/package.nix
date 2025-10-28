{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cryptsetup,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = "fido2luks";
    rev = version;
    hash = "sha256-bXwaFiRHURvS5KtTqIj+3GlGNbEulDgMDP51ZiO1w9o=";
  };

  cargoPatches = [
    ./0001-libcryptsetup-rs-bump-version-to-0.9-55.patch
    ./0002-cargo-update.patch
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ cryptsetup ];

  cargoHash = "sha256-WJXrT1jLytFkJ0gTE/4GYmfMqgqAyVFKi0SdyYGI/ug=";

  meta = {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mmahut ];
    platforms = lib.platforms.linux;
  };
}
