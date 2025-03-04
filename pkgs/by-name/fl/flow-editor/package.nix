{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_13,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D1pFP5tw323UJgWvLvh2sTiZG1hq5DP0FakdXEISRxs=";
  };
  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_0_13.hook
  ];

  passthru.updateScript = ./update.sh;

  env.VERSION = finalAttrs.version;

  meta = {
    description = "Programmer's text editor";
    homepage = "https://github.com/neurocyte/flow";
    changelog = "https://github.com/neurocyte/flow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "flow";
  };
})
