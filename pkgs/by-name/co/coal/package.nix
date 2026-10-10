{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  eigen,
  fontconfig,
  jrl-cmakemodules,
  assimp,
  octomap,
  qhull,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coal";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "coal-library";
    repo = "coal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lCTybqJPP7CuqdACjzuiR/kufu6fJxKhpa71/Z3oWXA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    assimp
    octomap
    qhull
    zlib
    boost
    eigen
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "COAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL" true)
    (lib.cmakeBool "COAL_HAS_QHULL" true)
    (lib.cmakeBool "INSTALL_DOCUMENTATION" true)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  outputs = [
    "dev"
    "out"
    "doc"
  ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/coal "$dev"
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  meta = {
    description = "Collision Detection Library, previously hpp-fcl";
    homepage = "https://github.com/coal-library/coal";
    changelog = "https://github.com/coal-library/coal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
