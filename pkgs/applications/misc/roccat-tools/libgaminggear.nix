{ stdenv, fetchurl, pkgconfig, cmake, pcre, gtk2, gtk3, libcanberra, libnotify, sqlite }:

stdenv.mkDerivation rec {
    name = "libgaminggear-${version}";
    version = "0.15.1";

    src = fetchurl {
        url = "mirror://sourceforge/libgaminggear/${name}.tar.bz2";
        sha256 = "0jf5i1iv8j842imgiixbhwcr6qcwa93m27lzr6gb01ri5v35kggz";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ cmake pcre gtk2 gtk3 libcanberra libnotify sqlite ];

    patchPhase = ''
        substituteInPlace configuration/FindGAMINGGEAR.cmake.in --replace '@GFX_PLUGIN_DIR@' 'lib/gaminggear_plugins'
    '';

    cmakeFlags = [
        "-DINSTALL_LIBDIR=lib"
        "-DINSTALL_CMAKE_MODULESDIR=lib/cmake"
        "-DINSTALL_PKGCONFIGDIR=lib/pkgconfig"
    ];

    meta = {
        description = "Supplementary libraries for roccat-tools";
        homepage = http://roccat.sourceforge.net;
        license = stdenv.lib.licenses.gpl2;
        platforms = stdenv.lib.platforms.linux;
        maintainers = [ stdenv.lib.maintainers.ashkitten ];
    };
}
