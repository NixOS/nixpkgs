{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "lspce-module";
  version = "1.1.0-unstable-2024-02-03";

  src = fetchFromGitHub {
    owner = "zbelial";
    repo = "lspce";
    rev = "543dcf0ea9e3ff5c142c4365d90b6ae8dc27bd15";
    hash = "sha256-LZWRQOKkTjNo8jecBRholW9SHpiK0SWcV8yObojpvxo=";
  };

  cargoHash = "sha256-pjDh7epCjqVN+QMzOIwujJ2MmNYS08QcVy/2VxGZsb0=";

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
