{ clang
, fetchFromGitHub
, lib
, llvmPackages
, protobuf
, rustPlatform
, writeShellScriptBin
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    sha256 = "sha256-NXuYUmo80rrBZCcuISKon48SKyyJrkzCEhggxaJNfBM=";
  };

  cargoSha256 = "sha256-PIORMTzQbMdlrKwuF4MiGrLlg2nQpgLRsaHHeiCbqrg=";

  nativeBuildInputs =
    let
      # this mocks git to return the truncated SHA hash we get from Nix
      fakeGit = writeShellScriptBin "git" ''
        echo ${builtins.substring 0 6 version}
      '';
    in
    [ clang fakeGit ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  PROTOC = "${protobuf}/bin/protoc";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.linux;
  };
}
