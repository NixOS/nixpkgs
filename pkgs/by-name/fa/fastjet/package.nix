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

  cmakeFlags = [
    (lib.cmakeBool "FASTJET_ENABLE_ALLCXXPLUGINS" true)
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
