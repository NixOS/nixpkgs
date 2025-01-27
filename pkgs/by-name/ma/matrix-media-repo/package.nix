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
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "t2bot";
    repo = "matrix-media-repo";
    rev = "v${version}";
    hash = "sha256-trVn+Mn98aJLQCpQX1+qps/uuA5+8zeDoM94eauxHO8=";
  };

  vendorHash = "sha256-fKDdL7C3L33caoXxlutzoND2izB5GH+5qTeojTskIUg=";

  asset-compiler = buildGoModule {
    pname = "${pname}-compile_assets";
    inherit version src vendorHash;

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
