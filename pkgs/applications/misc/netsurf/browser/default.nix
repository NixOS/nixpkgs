{ stdenv, fetchurl, fetchpatch, pkgconfig, libpng, openssl, curl, gtk2, check, SDL
, libxml2, libidn, perl, nettools, perlPackages, xxd
, libXcursor, libXrandr, makeWrapper
, libwebp
, uilib ? "framebuffer"
, buildsystem
, nsgenbind
, libnsfb
, libwapcaplet
, libparserutils
, libnslog
, libcss
, libhubbub
, libdom
, libnsbmp
, libnsgif
, libsvgtiny
, libnsutils
, libnspsl
, libutf8proc
, wrapGAppsHook
}:

stdenv.mkDerivation rec {

  name = "netsurf-${version}";
  version = "3.9";

  # UI libs incldue Framebuffer, and gtk

  src = fetchurl {
    url = "http://download.netsurf-browser.org/netsurf/releases/source/netsurf-${version}-src.tar.gz";
    sha256 = "1hzcm2s2wh5sapgr000lg63hcdbj6hyajxl43xa1x80kc5piqbyp";
  };

  patches = [
    # GTK: prefer using curl's intrinsic defaults for CURLOPT_CA*
    (fetchpatch {
	  name = "0001-GTK-prefer-using-curl-s-intrinsic-defaults-for-CURLO.patch";
      url = "http://source.netsurf-browser.org/netsurf.git/patch/?id=87177d8aa109206d131e0d80a2080ce55dab01c7";
      sha256 = "08bc60pc5k5qpckqv21zgmgszj3rpwskfc84shs8vg92vkimv2ai";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    xxd
  ] ++ stdenv.lib.optionals (uilib == "gtk") [
    wrapGAppsHook
  ];

  buildInputs = [ libpng openssl curl gtk2 check libxml2 libidn perl
    nettools perlPackages.HTMLParser libXcursor libXrandr makeWrapper SDL
    libwebp
    buildsystem
    nsgenbind
    libnsfb
    libwapcaplet
    libparserutils
    libnslog
    libcss
    libhubbub
    libdom
    libnsbmp
    libnsgif
    libsvgtiny
    libnsutils
    libnspsl
    libutf8proc
 ];

  preConfigure = ''
    cat <<EOF > Makefile.conf
    override NETSURF_GTK_RESOURCES := $out/share/Netsurf/${uilib}/res
    override NETSURF_USE_GRESOURCE := YES
    EOF
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
    "TARGET=${uilib}"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/Netsurf/${uilib}
    cmd=$(case "${uilib}" in framebuffer) echo nsfb;; gtk) echo nsgtk;; esac)
    cp $cmd $out/bin/netsurf
    tar -hcf - frontends/${uilib}/res | (cd $out/share/Netsurf/ && tar -xvpf -)
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set NETSURFRES $out/share/Netsurf/${uilib}/res
    )
  '' + stdenv.lib.optionalString (uilib != "gtk") ''
    wrapProgram $out/bin/netsurf "''${gappsWrapperArgs[@]}"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.netsurf-browser.org/;
    description = "Free opensource web browser";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
