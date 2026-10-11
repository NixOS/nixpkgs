{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "caqe";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "ltentrup";
    repo = "caqe";
    rev = version;
    sha256 = "sha256-TVh2bsVX318Ma/ATnv9QJtzsJtGyoBQsTXtTF6mWsJQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cryptominisat-5.6.6" = "sha256-KBRcnfUYg4iUHhufb93iHFk9n4c27XdONCKGycj7vmw=";
    };
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A solver for quantified Boolean formulas";
    homepage = "https://github.com/ltentrup/caqe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ viraptor ];
  };
}
