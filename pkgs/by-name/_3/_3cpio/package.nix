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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-NUOEeyYXAkQkUQuTQc+iIon0tuA5wAEZ6Q57iX++iB4=";
  };

  cargoHash = "sha256-wIGvEyB5DyCE62AxchW7ofrB53qOv4LM/VgpzEL+elc=";

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
