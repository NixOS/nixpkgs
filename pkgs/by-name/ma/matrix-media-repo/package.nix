{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libde265
, libheif
}:
let
  pname = "matrix-media-repo";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "t2bot";
    repo = "matrix-media-repo";
    rev = "v${version}";
    hash = "sha256-wC69OiB3HjRs/i46+E1YS+M4zKmvH5vENHyfgU7nt1I=";
  };

  vendorHash = "sha256-STzpKqn47qS0iogVYhFl4QBfKUtnqgxobqv1WaW6UtQ=";

  asset-compiler = buildGoModule {
    pname = "${pname}-compile_assets";
    inherit version src vendorHash;

    subPackages = [
      "cmd/utilities/compile_assets"
    ];
  };
in

buildGoModule {
  inherit pname version src vendorHash;

  patches = [
    ./synapse-import-u+x.patch
  ];

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
    "-X" "github.com/t2bot/matrix-media-repo/common/version.Version=${version}"
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
