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
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-LZu+g5ISpG/9ZZimTedvTjUEofhAaYKJdpLTex3ehQE=";
  };

  cargoHash = "sha256-YP6fCmY9fQD4hmKV6gLoElvce/BlRc9vAqyli7aaBNI=";

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
