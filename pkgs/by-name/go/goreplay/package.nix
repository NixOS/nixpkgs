{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  libpcap,
}:

buildGoModule rec {
  pname = "goreplay";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "buger";
    repo = "goreplay";
    rev = version;
    sha256 = "sha256-FiY9e5FgpPu+K8eoO8TsU3xSaSoPPDxYEu0oi/S8Q1w=";
  };

  patches = [
    # Fix build on arm64-linux, see https://github.com/buger/goreplay/pull/1140
    (fetchpatch {
      url = "https://github.com/buger/goreplay/commit/a01afa1e322ef06f36995abc3fda3297bdaf0140.patch";
      sha256 = "sha256-w3aVe/Fucwd2OuK5Fu2jJTbmMci8ilWaIjYjsWuLRlo=";
    })
  ];

  vendorHash = "sha256-jDMAtcq3ZowFdky5BdTkVNxq4ltkhklr76nXYJgGALg=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [ libpcap ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/buger/goreplay";
    license = lib.licenses.lgpl3Only;
    description = "Open-source tool for capturing and replaying live HTTP traffic";
    maintainers = with lib.maintainers; [ lovek323 ];
    mainProgram = "goreplay";
  };
}
