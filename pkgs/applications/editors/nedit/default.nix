{
  lib,
  stdenv,
  fetchurl,
  motif,
  libXpm,
  libXt,
}:

stdenv.mkDerivation rec {
  pname = "nedit";
  version = "5.7";

  src = fetchurl {
    url = "mirror://sourceforge/nedit/nedit-source/${pname}-${version}-src.tar.gz";
    sha256 = "0ym1zhjx9976rf2z5nr7dj4mjkxcicimhs686snjhdcpzxwsrndd";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [
    motif
    libXpm
    libXt
  ];

  # the linux config works fine on darwin too!
  buildFlags = lib.optional (stdenv.isLinux || stdenv.isDarwin) "linux";

  env.NIX_CFLAGS_COMPILE = "-DBUILD_UNTESTED_NEDIT -L${motif}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp -p source/nedit source/nc $out/bin
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/nedit";
    description = "Fast, compact Motif/X11 plain text editor";
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
}
