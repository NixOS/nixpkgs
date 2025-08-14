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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-UtXyJ4PDzi4BJ0nd9w/hygcJVfNd3H5WAIV+f23dtpk=";
  };

  cargoHash = "sha256-XGTa5Ui4yPHmuC4tTWGMTKN/erHSaiJVmxHglbt+udg=";

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
