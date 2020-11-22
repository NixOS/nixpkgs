{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config, cmake, protobuf
, zlib, bzip2, openssl, leveldb
, nodePackages, curl, gnumake, git
, libredirect
, portable ? true
}:

let
  # Contains the data required by the deposit_contract
  # See `common/deposit_contract/build.rs` in the lighthous source for exact version
  eth2specs = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth2.0-specs";
    rev = "v0.12.1";
    sha256 = "05irxnskcsdbp844hgk2hwkjmgfjxin99jr1fl5b5wg1v7v7gl4y";
  };
  eth2specs_unsafe = fetchFromGitHub {
    owner = "sigp";
    repo = "unsafe-eth2-deposit-contract";
    # NOTE: the version of the unsafe contract lags the main tag, but the v0.9.2.1 code is compatible
    # with the unmodified v0.12.1 contract. See `common/deposit_contract/build.rs` for details.
    rev = "v0.9.2.1";
    sha256 = "151ahdj5114xb5hbhzsx5rx4yyry832hhm0bkx36s2np3r8v883q";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    sha256 = "13pacp39splz6glinz0fy58fb0lsbqp54ndb2d4w9xb716yr1vnk";
  };

  # Patch version check to not rely on git
  postPatch = ''
    substituteInPlace common/lighthouse_version/src/lib.rs \
      --replace 'fallback = "unknown"' 'fallback = "Lighthouse/v${version}"' \
      --replace 'r"^Lighthouse/v[0-9]+\.[0-9]+\.[0-9]+(-rc.[0-9])?-[[:xdigit:]]{7}\+?$"' 'r"^Lighthouse/v[0-9]+\.[0-9]+\.[0-9]+(-rc.[0-9])?$"'
  '';

  # LevelDB can't be unvendored and it requires cmake to be built
  nativeBuildInputs = [ pkg-config cmake protobuf git ];
  buildInputs = [ openssl zlib bzip2 leveldb ];
  checkInputs = [ nodePackages.ganache-cli curl ];

  preConfigure = ''
    # Needed to get openssl-sys to use pkg-config.
    export OPENSSL_NO_VENDOR=1

    # Prost build needs this
    export PROTOC="${protobuf}/bin/protoc"
    export PROTOC_INCLUDE="${protobuf}/include"

    # Use the pre fetched files instead of downloading them during build
    export LIGHTHOUSE_DEPOSIT_CONTRACT_SPEC_URL="file://${eth2specs}/deposit_contract/contracts/validator_registration.json"
    export LIGHTHOUSE_DEPOSIT_CONTRACT_TESTNET_URL="file://${eth2specs_unsafe}/unsafe_validator_registration.json"
  '';

  cargoBuildFlags = [ "--features" "${lib.optionalString portable "portable,"}" ];

  cargoSha256 = "1i84gf7as3hkk6x5ir9br2sfxrh490704sdiqp44an005hlbaiav";

  checkFlags = [
    # these want internet access, disable them
    "--skip=generated"
  ];

  # Make /etc/resolv.conf available in sandbox
  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  meta = with lib; {
    description = "An open-source Ethereum 2.0 client, written in Rust.";
    homepage = "https://github.com/sigp/lighthouse";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
  };
}
