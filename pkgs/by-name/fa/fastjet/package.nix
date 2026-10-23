{
  lib,
  stdenv,
  fetchurl,
  python ? null,
  withPython ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastjet";
  version = "3.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://fastjet.fr/repo/fastjet-${finalAttrs.version}.tar.gz";
    hash = "sha256-mkFUFj5yBB3uP93pyyToFGJeF4CRqHNKatU3XlNxtCM=";
  };

  postPatch = ''
    patchShebangs --build fastjet-config.in
  '';

  nativeBuildInputs = lib.optionals withPython [ python ];

  configureFlags = [
    "--enable-allcxxplugins"
  ]
  ++ lib.optionals withPython [ "--enable-pyext" ];

  enableParallelBuilding = true;

  meta = {
    description = "Software package for jet finding in pp and e+e− collisions";
    mainProgram = "fastjet-config";
    license = lib.licenses.gpl2Plus;
    homepage = "http://fastjet.fr/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
