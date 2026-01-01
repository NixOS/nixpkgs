{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "avbroot";
<<<<<<< HEAD
  version = "3.23.3";
=======
  version = "3.23.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Bdr9oEBIbRyEBhUbY3lIqhtE0l+MklWkwJ1vViYloiM=";
  };

  cargoHash = "sha256-nT1mKRc9UTeday0ZiJEXTRckKSWpX/tYdcV6Izqwg60=";
=======
    hash = "sha256-rS3V+D7dBt/px0UNC8ZZyQ4FzNsjTykMSeXbjFF6iis=";
  };

  cargoHash = "sha256-XX2u281qTwI6/GwujseIiAmlsYPgxkA7cxyIljv29tk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ bzip2 ];

  meta = {
    description = "Sign (and root) Android A/B OTAs with custom keys while preserving Android Verified Boot";
    homepage = "https://github.com/chenxiaolong/avbroot";
    changelog = "https://github.com/chenxiaolong/avbroot/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "avbroot";
  };
}
