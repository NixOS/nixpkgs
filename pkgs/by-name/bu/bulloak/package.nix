{ lib
, fetchFromGitHub
, rustPlatform
, fetchurl
, stdenv
, darwin
}:

let
  # svm-rs-builds requires a list of solc versions to build, and would make network calls if not provided.
  # The ethereum project does not provide static binaries for aarch64, so we use separate sources, the same as in
  # svm-rs's source code.
  solc-versions = {
    x86_64-linux = fetchurl {
      url = "https://raw.githubusercontent.com/ethereum/solc-bin/60de887187e5670c715931a82fdff6677b31f0cb/linux-amd64/list.json";
      hash = "sha256-zm1cdqSP4Y9UQcq9OV8sXxnzr3+TWdc7mdg+Do8Y7WY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://raw.githubusercontent.com/ethereum/solc-bin/60de887187e5670c715931a82fdff6677b31f0cb/macosx-amd64/list.json";
      hash = "sha256-uUdd5gCG7SHQgAW2DQXemTujb8bUJM27J02WjLkQgek=";
    };
    aarch64-linux = fetchurl {
      url = "https://raw.githubusercontent.com/nikitastupin/solc/923ab4b852fadc00ffe87bb76fff21d0613bd280/linux/aarch64/list.json";
      hash = "sha256-mJaEN63mR3XdK2FmEF+VhLR6JaCCtYkIRq00wYH6Xx8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://raw.githubusercontent.com/alloy-rs/solc-builds/260964c1fcae2502c0139070bdc5c83eb7036a68/macosx/aarch64/list.json";
      hash = "sha256-xrtb3deMDAuDIjzN1pxm5NyW5NW5OyoOHTFsYyWJCYY=";
    };
  };
in
rustPlatform.buildRustPackage rec {
  pname = "bulloak";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "alexfertel";
    repo = "bulloak";
    rev = "v${version}";
    hash = "sha256-0pzn0gXlhdndCpsrVRNxl1ylIE/S9A0l8VjNn5wDVvw=";
  };

  cargoHash = "sha256-IlDbys5uluLm418UkGf+FIM1AfR2IBAZQ4Atqlybajw=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  # tests run in CI on the source repo
  doCheck = false;

  # provide the list of solc versions to the `svm-rs-builds` dependency
  SVM_RELEASES_LIST_JSON = solc-versions.${stdenv.hostPlatform.system};

  meta = with lib; {
    description = "Solidity test generator based on the Branching Tree Technique";
    homepage = "https://github.com/alexfertel/bulloak";
    license = with licenses; [ mit asl20 ];
    mainProgram = "bulloak";
    maintainers = with maintainers; [ beeb ];
  };
}
