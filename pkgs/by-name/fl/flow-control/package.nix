{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_14,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jt7KJEg5300IuO7m7FiC8zejmymqMqdT7FtoVhTR05M=";
  };
  postPatch = ''
    ln -s ${
      callPackage ./build.zig.zon.nix {
        zig = zig_0_14;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_0_14.hook
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
