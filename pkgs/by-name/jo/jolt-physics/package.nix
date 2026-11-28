{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jolt-physics";
  version = "5.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jrouwe";
    repo = "JoltPhysics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-igPNGwYtXjR2BXKD20/uzfn7x7JwBdbVjMQIk957+TU=";
  };

  cmakeDir = "../Build";
  cmakeBuildDir = "builddir"; # avoid case-insensitive conflict with ./Build

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A multi core friendly rigid body physics and collision detection library.";
    homepage = "https://github.com/jrouwe/JoltPhysics";
    changelog = "https://github.com/jrouwe/JoltPhysics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amarshall ];
    platforms = lib.platforms.unix;
  };
})
