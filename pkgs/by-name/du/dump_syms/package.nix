{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,

  # tests
  firefox-esr-unwrapped,
  firefox-unwrapped,
  thunderbird-unwrapped,
}:

let
  pname = "dump_syms";
  version = "2.3.5";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "dump_syms";
    rev = "v${version}";
    hash = "sha256-zxYGxqnh6urXDC/ZQf3aFzBqOj5QNulyDpTsZ47BDkU=";
  };

  cargoHash = "sha256-gnXf6APcEJJKpKsqsBPLXlZddEt+6ENyt15iDw8XShc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # Disable tests that require network access
    # ConnectError("dns error", Custom { kind: Uncategorized, error: "failed to lookup address information: Temporary failure in name resolution" })) }', src/windows/pdb.rs:725:56
    "--skip windows::pdb::tests::test_ntdll"
    "--skip windows::pdb::tests::test_oleaut32"
  ];

  passthru.tests = {
    inherit firefox-esr-unwrapped firefox-unwrapped thunderbird-unwrapped;
  };

  meta = {
    changelog = "https://github.com/mozilla/dump_syms/blob/v${version}/CHANGELOG.md";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    mainProgram = "dump_syms";
    license = lib.licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with lib.maintainers; [ hexa ];
  };
}
