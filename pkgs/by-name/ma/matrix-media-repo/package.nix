{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libde265,
  libheif,
}:
let
  pname = "matrix-media-repo";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "t2bot";
    repo = "matrix-media-repo";
    rev = "v${version}";
    hash = "sha256-KP1ZyHqeATxk1PCLuM6lPk+GB4Rd0f7ppKVETIURx28=";
  };

  patches = [
    # matrix-media-repo 1.3.8+ uses a Go wrapper expecting libheif 1.19+
    # which NixOS 24.11 does not have
    ./downgrade-libheif-wrapper.diff
  ];

  vendorHash = "sha256-3cmjdhL4U7tq429vUPElM5Kp203SWgZeoHM/i6Vuf7Q=";

  asset-compiler = buildGoModule {
    pname = "${pname}-compile_assets";
    inherit
      version
      src
      patches
      vendorHash
      ;

    subPackages = [
      "cmd/utilities/compile_assets"
    ];
  };
in

buildGoModule {
  inherit
    pname
    version
    src
    patches
    vendorHash
    ;

  nativeBuildInputs = [
    pkg-config
    asset-compiler
  ];

  buildInputs = [
    libde265
    libheif
  ];

  preBuild = ''
    compile_assets
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/t2bot/matrix-media-repo/common/version.Version=${version}"
  ];

  doCheck = false; # requires docker

  meta = with lib; {
    description = "Highly configurable multi-domain media repository for Matrix";
    homepage = "https://github.com/t2bot/matrix-media-repo";
    changelog = "https://github.com/t2bot/matrix-media-repo/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "media_repo";
  };
}
