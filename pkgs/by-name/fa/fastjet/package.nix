{
  lib,
  stdenv,
  fetchurl,
  cmake,
  python ? null,
  withPython ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastjet";
  version = "3.5.1";

  src = fetchurl {
    url = "https://fastjet.fr/repo/fastjet-${finalAttrs.version}.tar.gz";
    hash = "sha256-mkFUFj5yBB3uP93pyyToFGJeF4CRqHNKatU3XlNxtCM=";
  };

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = lib.optional withPython python;

  postPatch = ''
    # HAS_SHARED is never set in the current fastjet's CMakeLists.txt
    # Remove for 3.5.2
    substituteInPlace fastjet-config.in \
      --replace-fail '@HAS_SHARED@' 'yes'
  '';

  cmakeFlags = [
    (lib.cmakeBool "FASTJET_ENABLE_ALLCXXPLUGINS" true)
    # These are substituted in .pc files, and can't be absolute paths
    (lib.cmakeOptionType "STRING" "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeOptionType "STRING" "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  ++ lib.optional withPython (lib.cmakeBool "FASTJET_ENABLE_PYTHON" true);

  meta = {
    description = "Software package for jet finding in pp and e+e− collisions";
    mainProgram = "fastjet-config";
    license = lib.licenses.gpl2Plus;
    homepage = "http://fastjet.fr/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
