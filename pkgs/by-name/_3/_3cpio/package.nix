{
  fetchFromGitHub,
  lib,
  lz4,
  lzop,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "3cpio";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-1kdJSwe9v7ojdukj04/G/RDeEk0NVCXmiNoVaelqt4Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-axPghG1T5NZYzGRZBwtdBJ5tQh+h8/vep/EmL5ADCjE=";

  # Tests attempt to access arbitrary filepaths
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage initrd cpio archives";
    homepage = "https://github.com/bdrung/3cpio";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "3cpio";
  };
}
