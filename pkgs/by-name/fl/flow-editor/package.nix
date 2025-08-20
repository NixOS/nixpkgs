{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_13,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dXWqxV66BwtjOvmreq4+u5+xBI+1v1PAep8RQBK3rlA=";
  };
  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_0_13.hook
  ];

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
