{
  fetchFromGitHub,
  lib,
  lz4,
  lzop,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "3cpio";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-4ERSH5Kz/e2MuIIgi3XQVnhW0csBPDIvdmEw05OdREA=";
  };

  cargoHash = "sha256-ER1OQZHHtHBNPoEl4NJ5p5KYjzFgJnFR8nXcmCk2HTA=";

  # Tests attempt to access arbitrary filepaths
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage initrd cpio archives";
    homepage = "https://github.com/bdrung/3cpio";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "3cpio";
    # broken due to signature mismatch in libc crate on darwin:
    # https://github.com/rust-lang/libc/issues/4360
    broken = stdenv.hostPlatform.isDarwin;
  };
}
