{ lib
, stdenv
, fetchurl
, SDL
, check
, curl
, expat
, gperf
, gtk2
, gtk3
, libXcursor
, libXrandr
, libidn
, libjpeg
, libjxl
, libpng
, libwebp
, libxml2
, makeWrapper
, openssl
, perlPackages
, pkg-config
, wrapGAppsHook3
, xxd

# Netsurf-specific dependencies
, buildsystem
, libcss
, libdom
, libhubbub
, libnsbmp
, libnsfb
, libnsgif
, libnslog
, libnspsl
, libnsutils
, libparserutils
, libsvgtiny
, libutf8proc
, libwapcaplet
, nsgenbind

# Configuration
, uilib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf";
  version = "3.11";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/netsurf-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-wopiau/uQo0FOxP4i1xECSIkWXZSLRLq8TfP0y0gHLI=";
  };

  nativeBuildInputs = [
    makeWrapper
    perlPackages.HTMLParser
    perlPackages.perl
    pkg-config
    xxd
  ]
  ++ lib.optional (uilib == "gtk2" || uilib == "gtk3") wrapGAppsHook3;

  buildInputs = [
    check
    curl
    gperf
    libXcursor
    libXrandr
    libidn
    libjpeg
    libjxl
    libpng
    libwebp
    libxml2
    openssl

    libcss
    libdom
    libhubbub
    libnsbmp
    libnsfb
    libnsgif
    libnslog
    libnspsl
    libnsutils
    libparserutils
    libsvgtiny
    libutf8proc
    libwapcaplet
    nsgenbind
  ]
  ++ lib.optionals (uilib == "framebuffer") [ expat SDL ]
  ++ lib.optional (uilib == "gtk2") gtk2
  ++ lib.optional (uilib == "gtk3") gtk3
  ;

  # Since at least 2018 AD, GCC and other compilers run in `-fno-common` mode as
  # default, in order to comply with C standards and also get rid of some bad
  # quality code. Because of this, many codebases that weren't updated need to
  # be patched -- or the `-fcommon` flag should be explicitly passed to the
  # compiler

  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=85678
  # https://github.com/NixOS/nixpkgs/issues/54506

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  env.CFLAGS = lib.optionalString stdenv.isDarwin "-D_DARWIN_C_SOURCE";

  patchPhase = lib.optionalString stdenv.cc.isClang ''
    runHook prePatch

    substituteInPlace Makefile \
      --replace-warn '--trace' '-t' \
      --replace-warn '-Wimplicit-fallthrough=3' '-Wimplicit-fallthrough'

    runHook postPatch
  '';

  preConfigure = ''
    cat <<EOF > Makefile.config
    override NETSURF_GTK_RES_PATH  := $out/share/
    override NETSURF_USE_GRESOURCE := YES
    EOF
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "TARGET=${uilib}"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Free, open source, small web browser";
    mainProgram = "netsurf-gtk3";
    longDescription = ''
      NetSurf is a free, open source web browser. It is written in C and
      released under the GNU Public Licence version 2. NetSurf has its own
      layout and rendering engine entirely written from scratch. It is small and
      capable of handling many of the web standards in use today.
    '';
    license = lib.licenses.gpl2Only;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
