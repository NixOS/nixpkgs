{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "replibyte";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "replibyte";
    rev = "v${version}";
    hash = "sha256-VExA92g+1y65skxLKU62ZPUPOwdm9N73Ne9xW7Q0Sic=";
  };

  cargoPatches = [
    ./bump-crates.patch
  ];

  cargoHash = "sha256-RPY1M5zRMYgzICn2BBJrIn3LFa6T9PKBfpPUXtkgeQo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Fix undefined reference to `__rust_probestack` from wasmer_vm.
  # Define it as a no-op since it's only needed for stack overflow detection.
  env.RUSTFLAGS = "-C link-arg=-Wl,--defsym,__rust_probestack=0";

  cargoBuildFlags = [ "--all-features" ];

  doCheck = false; # requires multiple dbs to be installed

  meta = with lib; {
    description = "Seed your development database with real data";
    mainProgram = "replibyte";
    homepage = "https://github.com/Qovery/replibyte";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
