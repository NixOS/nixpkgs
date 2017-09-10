{ stdenv, fetchFromGitHub, cairo, gdk_pixbuf, libconfig, pango, pkgconfig
, xcbutilwm, alsaLib, wirelesstools, asciidoc, libxslt
}:

stdenv.mkDerivation rec {
  name    = "yabar-${version}";
  version = "2017-09-09";

  src = fetchFromGitHub {
    owner  = "geommer";
    repo   = "yabar";
    rev    = "d3934344ba27f5bdf122bf74daacee6d49284dab";
    sha256 = "14zrlzva8i83ffg426mrf6yli8afwq6chvc7yi78ngixyik5gzhx";
  };

  buildInputs = [
    cairo gdk_pixbuf libconfig pango pkgconfig xcbutilwm
    alsaLib wirelesstools asciidoc libxslt
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "\$(shell git describe)" "${version}" \
      --replace "a2x" "${asciidoc}/bin/a2x --no-xmllint"
  '';

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

  postInstall = ''
    mkdir -p $out/share/yabar/examples
    cp -v examples/*.config $out/share/yabar/examples
  '';

  meta = with stdenv.lib; {
    description = "A modern and lightweight status bar for X window managers";
    homepage    = https://github.com/geommer/yabar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
