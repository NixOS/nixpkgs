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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-BKJ1DIKRcOviWyz6cituxSynzZSvVvR1muesL91cIAg=";
  };

  cargoHash = "sha256-q3WcEv2JF6SHdeFPSJrx0aE/DU/v08ihZjklJRVLwPY=";

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
