{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  nix-update-script,
  callPackage,
  curl,
  expat,
  pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hys";
  version = "0.3.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "paulilaaso";
    repo = "hys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EBB8atRZ9mwpee+SOEuiIbMsFk3UH7JIiE3k9Rk8LWE=";
  };

  nativeBuildInputs = [
    zig_0_16
    pkg-config
  ];

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  patches = [
    ./fix-build.patch
  ];

  buildInputs = [
    expat
    curl
  ];

  deps = callPackage ./build.zig.zon.nix { };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal RSS Reader for Digital Minimalists — Tool for Escaping the Doomscroll";
    homepage = "https://github.com/paulilaaso/hys";
    changelog = "https://github.com/paulilaaso/hys/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "hys";
    inherit (zig_0_16.meta) platforms;
  };
})
