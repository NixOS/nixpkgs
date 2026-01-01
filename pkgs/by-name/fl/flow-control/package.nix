{
  lib,
  fetchFromGitHub,
  stdenv,
<<<<<<< HEAD
  zig_0_15,
  callPackage,
}:

let
  zig_hook = zig_0_15.hook.overrideAttrs {
    zig_default_flags = "-Dcpu=baseline -Doptimize=ReleaseSafe --color off";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.6.0";
=======
  zig_0_14,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-868FK3wr/fjXzrQJ4YVDBvzNuX818lufEx/K0fvJdWo=";
=======
    hash = "sha256-jt7KJEg5300IuO7m7FiC8zejmymqMqdT7FtoVhTR05M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  postPatch = ''
    ln -s ${
      callPackage ./build.zig.zon.nix {
<<<<<<< HEAD
        zig = zig_0_15;
=======
        zig = zig_0_14;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
<<<<<<< HEAD
    zig_hook
=======
    zig_0_14.hook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
