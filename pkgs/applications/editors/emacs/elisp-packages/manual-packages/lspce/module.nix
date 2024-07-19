{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "lspce-module";
  version = "1.1.0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "01b77a4f544a912409857083842db51a20bfdbf3";
    hash = "sha256-oew5EujNYGjk/agBw3ECAVe7GZl8rw/4M5t32JM+1T8=";
  };

  cargoHash = "sha256-YLcSaFHsm/Iw7Q3y/YkfdbYKUPW0DRmaZnZ1A9vKR14=";

  checkFlags = [
    # flaky test
    "--skip=msg::tests::serialize_request_with_null_params"
  ];

  # rename module without changing either suffix or location
  # use for loop because there seems to be two modules on darwin systems
  # https://github.com/zbelial/lspce/issues/7#issue-1783708570
  postInstall = ''
    for f in $out/lib/*; do
      mv --verbose $f $out/lib/lspce-module.''${f##*.}
    done
  '';

  meta = {
    homepage = "https://github.com/zbelial/lspce";
    description = "LSP Client for Emacs implemented as a module using Rust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
