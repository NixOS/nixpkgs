{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  applyPatches,
}:

buildGoModule (finalAttrs: {
  pname = "gobusybox";
  version = "0.2.0-unstable-2024-03-05";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "u-root";
      repo = "gobusybox";
      rev = "d8fbaca23e26beab648c86c8a67335ad65d0d15c";
      hash = "sha256-hS6YwN6eekyDjp7E6sisW+8HO5WHTEC68XyKZFPihK4=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/u-root/gobusybox/commit/4204bda4af46406562e377e23ec6f9c87bfbda84.patch";
        hash = "sha256-3AOl/sxBZVLhLnSnqY3H8V6BBEjh+3gW3aPS5Wqob4s=";
      })
    ];
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

  vendorHash = "sha256-xezqzOPTCIdoT2t0rFqYa/1uO1YIIEeXSUV62YLUeOQ=";

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
