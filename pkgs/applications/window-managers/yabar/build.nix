{ stdenv, fetchFromGitHub, cairo, gdk_pixbuf, libconfig, pango, pkgconfig
, xcbutilwm, alsaLib, wirelesstools, asciidoc, libxslt, makeWrapper, docbook_xsl
, configFile ? null, lib
, rev, sha256, version
, playerctl
}:

stdenv.mkDerivation {
  name = "yabar-${version}";

  src = fetchFromGitHub {
    inherit rev sha256;

    owner = "geommer";
    repo  = "yabar";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cairo gdk_pixbuf libconfig pango xcbutilwm docbook_xsl
    alsaLib wirelesstools asciidoc libxslt makeWrapper
    playerctl
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "\$(shell git describe)" "${version}" \
      --replace "a2x" "${asciidoc}/bin/a2x --no-xmllint"
  '';

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" "PLAYERCTL=1" ];

  postInstall = ''
    mkdir -p $out/share/yabar/examples
    cp -v examples/*.config $out/share/yabar/examples

    ${lib.optionalString (configFile != null)
      ''
        wrapProgram "$out/bin/yabar" \
          --add-flags "-c ${configFile}"
      ''
    }
  '';

  meta = with stdenv.lib; {
    description = "A modern and lightweight status bar for X window managers";
    homepage    = https://github.com/geommer/yabar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
