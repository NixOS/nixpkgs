{
  lib,
  # Build fails with Go 1.25, with the following error:
  # 'vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go:64:9: invalid array length -delta * delta (constant -256 of type int64)'
  # Wait for upstream to update their vendored dependencies before unpinning.
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module (finalAttrs: {
  pname = "gobusybox";
  version = "0.2.0-unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "gobusybox";
    rev = "d8fbaca23e26beab648c86c8a67335ad65d0d15c";
    hash = "sha256-hS6YwN6eekyDjp7E6sisW+8HO5WHTEC68XyKZFPihK4=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  subPackages = [
    "cmd/gencmddeps"
    "cmd/goanywhere"
    "cmd/makebb"
    "cmd/makebbmain"
    "cmd/rewritepkg"
  ];

  env.CGO_ENABLED = "0";

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
})
