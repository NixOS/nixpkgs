{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ord";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = version;
    hash = "sha256-rqyf2GZ3lhYSSr14S+JXJYCYZC+7BbFzxLOourykMas=";
  };

  cargoHash = "sha256-SjD5S8GVjfpIvA++eiNebn9M33aRvrXL+MyqZTK2e4U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    "--skip=subcommand::server::tests::status" # test fails if it built from source tarball
  ];

  meta = with lib; {
    description = "Index, block explorer, and command-line wallet for Ordinals";
    homepage = "https://github.com/ordinals/ord";
    changelog = "https://github.com/ordinals/ord/blob/${src.rev}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "ord";
  };
}
