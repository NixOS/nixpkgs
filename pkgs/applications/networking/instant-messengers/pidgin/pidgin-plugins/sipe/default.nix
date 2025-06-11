{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pidgin,
  intltool,
  libxml2,
  gmime,
  nss,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-sipe";
  version = "1.25.0";

  src = fetchurl {
    url = "mirror://sourceforge/sipe/${pname}-${version}.tar.gz";
    sha256 = "0262sz00iqxylx0xfyr48xikhiqzr8pg7b4b7vwj5iv4qxpxv939";
  };

  patches = [
    # add sipe_utils_memdup() function
    (fetchpatch {
      url = "https://repo.or.cz/siplcs.git/patch/567d0ddc0692adfef5f15d0d383825a9b2ea4b49";
      sha256 = "24L8ZfoOGc3JoTCGxuTNjuHzt5QgFDu1+vSoJpGvde4=";
    })
    # replace g_memdup() with sipe_utils_memdup()
    # g_memdup is deprecatein newer Glib
    (fetchpatch {
      url = "https://repo.or.cz/siplcs.git/patch/583a734e63833f03d11798b7b0d59a17d08ae60f";
      sha256 = "Ai6Czpy/FYvBi4GZR7yzch6OcouJgfreI9HcojhGVV4=";
    })
    ./0001-fix-libxml-error-signature.patch
  ];

  nativeBuildInputs = [ intltool ];
  buildInputs = [
    pidgin
    gmime
    libxml2
    nss
  ];
  configureFlags = [
    "--without-dbus"
    "--enable-quality-check=no"
  ];

  enableParallelBuilding = true;

  postInstall = "ln -s \$out/lib/purple-2 \$out/share/pidgin-sipe";

  meta = with lib; {
    description = "SIPE plugin for Pidgin IM";
    homepage = "http://sipe.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
