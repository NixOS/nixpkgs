{
  lib,
  stdenv,
  fetchurl,
  python ? null,
  withPython ? false,
}:

stdenv.mkDerivation rec {
  pname = "fastjet";
  version = "3.4.3";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    hash = "sha256-zBdUcb+rhla4xhg6jl6a0F1fdQbkbzISqagjCQW49qM=";
  };

  postPatch = ''
    patchShebangs --build fastjet-config.in
  '';

  buildInputs = lib.optional withPython python;

  configureFlags = [
    "--enable-allcxxplugins"
  ] ++ lib.optional withPython "--enable-pyext";

  enableParallelBuilding = true;

  meta = {
    description = "Software package for jet finding in pp and e+e− collisions";
    mainProgram = "fastjet-config";
    license = lib.licenses.gpl2Plus;
    homepage = "http://fastjet.fr/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
