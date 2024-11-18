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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "chenxiaolong";
    repo = "avbroot";
    rev = "refs/tags/v${version}";
    hash = "sha256-gG8pR/D5oaPPqq0e815J6z+dDVxh4VSoHIm1Yl3x2p4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9FM6r7+R9aR0lYJdJxnCuGKLXZ71Ia9UVmY4Pk9UAqw=";

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
