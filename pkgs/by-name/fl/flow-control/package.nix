{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_15,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-868FK3wr/fjXzrQJ4YVDBvzNuX818lufEx/K0fvJdWo=";
  };
  postConfigure = ''
    ln -s ${
      callPackage ./build.zig.zon.nix {
        zig = zig_0_15;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [ zig_0_15 ];

  passthru.updateScript = ./update.sh;

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "-Dcpu=baseline"
    "-Doptimize=ReleaseSafe"
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
