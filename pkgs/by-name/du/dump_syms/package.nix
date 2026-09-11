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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dump_syms";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "dump_syms";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IuWuMomxbMg/fvxAP/8hOZdWe4nHzqkzPaXQwrA9IVU=";
  };

  cargoHash = "sha256-A7qHSmJNRhmRjyQJpkr2SVLuTy4g4i3TeERlJqJYxkM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    # Disable tests that require network access
    # ConnectError("dns error", Custom { kind: Uncategorized, error: "failed to lookup address information: Temporary failure in name resolution" })) }', src/windows/pdb.rs:725:56
    "--skip=windows::pdb::tests::test_ntdll"
    "--skip=windows::pdb::tests::test_oleaut32"
  ];

  passthru.tests = {
    inherit firefox-esr-unwrapped firefox-unwrapped thunderbird-unwrapped;
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/mozilla/dump_syms/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Command-line utility for parsing the debugging information the compiler provides in ELF or stand-alone PDB files";
    mainProgram = "dump_syms";
    license = lib.licenses.asl20;
    homepage = "https://github.com/mozilla/dump_syms/";
    maintainers = with lib.maintainers; [ hexa ];
  };
})
