{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchurl,
  stdenv,
}:

let
  # svm-rs-builds requires a list of solc versions to build, and would make network calls if not provided.
  # The ethereum project does not provide static binaries for aarch64, so we use separate sources, the same as in
  # svm-rs's source code.
  solc-versions = {
    x86_64-linux = fetchurl {
      url = "https://raw.githubusercontent.com/ethereum/solc-bin/bdd7dd3fda6e4a00c0697d891a1a7ae9f2b3a5fd/linux-amd64/list.json";
      hash = "sha256-H6D6XbIw5sDZlbc2c51vIMRmOqs2nDIcaNzCaOvnLsw=";
    };
    x86_64-darwin = fetchurl {
      url = "https://raw.githubusercontent.com/ethereum/solc-bin/bdd7dd3fda6e4a00c0697d891a1a7ae9f2b3a5fd/macosx-amd64/list.json";
      hash = "sha256-A3A6gtNb129tD5KC0tCXvlzQ11t5SrNrX8tQeq73+mY=";
    };
    aarch64-linux = fetchurl {
      url = "https://raw.githubusercontent.com/nikitastupin/solc/99b5867237b37952d372e0dab400d6788feda315/linux/aarch64/list.json";
      hash = "sha256-u6WRAcnR9mN9ERfFdLOxxSc9ASQIQvmS8uG+Z4H6OAU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://raw.githubusercontent.com/alloy-rs/solc-builds/e4b80d33bc4d015b2fc3583e217fbf248b2014e1/macosx/aarch64/list.json";
      hash = "sha256-h0B1g7x80jU9iCFCMYw+HlmdKQt1wfhIkV5W742kw6w=";
    };
  };
in
rustPlatform.buildRustPackage rec {
  pname = "bulloak";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "alexfertel";
    repo = "bulloak";
    rev = "v${version}";
    hash = "sha256-8Qp8ceafAkw7Tush/dvBl27q5oNDzbOqyvSLXhjf4fo=";
  };

  cargoHash = "sha256-yaRaB3U8Wxhp7SK5E44CF8AudhG7ar7L5ey+CRVfYqc=";

  # tests run in CI on the source repo
  doCheck = false;

  # provide the list of solc versions to the `svm-rs-builds` dependency
  SVM_RELEASES_LIST_JSON =
    solc-versions.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Solidity test generator based on the Branching Tree Technique";
    homepage = "https://github.com/alexfertel/bulloak";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "bulloak";
    maintainers = with lib.maintainers; [ beeb ];
  };
}
