{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jrl-cmakemodules";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQaa+fqyGy12CrMeP22khNxDhmtsu8I6naFUOcao4Yg=";
  };

  # Relax version constraint in dependencies.
  # Remove this when nixpkgs-review is happy without.
  # All failures are fixed upstream but not yet in released versions
  postPatch = ''
    substituteInPlace base.cmake --replace-fail \
      "if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.22)" \
      "if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
})
