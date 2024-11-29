{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gobusybox";
  version = "0.2.0-unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "gobusybox";
    rev = "d8fbaca23e26beab648c86c8a67335ad65d0d15c";
    hash = "sha256-hS6YwN6eekyDjp7E6sisW+8HO5WHTEC68XyKZFPihK4=";
  };

  sourceRoot = "${src.name}/src";

  subPackages = [
    "cmd/gencmddeps"
    "cmd/goanywhere"
    "cmd/makebb"
    "cmd/makebbmain"
    "cmd/rewritepkg"
  ];

  CGO_ENABLED = "0";

  vendorHash = "sha256-s4bQLXNFhyAk+UNI1xJXQABjBXtPFXiWvmdttV/6Bm8=";

  ldflags = [ "-s" ];

  meta = {
    description = "Tools for compiling many Go commands into one binary to save space";
    longDescription = "Builds are supported for vendor-based Go and module-based Go";
    homepage = "https://github.com/u-root/gobusybox";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "makebb";
  };
}
