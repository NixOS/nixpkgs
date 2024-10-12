{ stdenv, fetchFromGitHub, cairo, gdk-pixbuf, libconfig, pango, pkg-config
, xcbutilwm, alsa-lib, wirelesstools, asciidoc, libxslt, makeWrapper, docbook_xsl
, configFile ? null, lib
, rev, sha256, version, patches ? []
}:

stdenv.mkDerivation {
  pname = "yabar";
  inherit version;

  src = fetchFromGitHub {
    inherit rev sha256;

    owner = "geommer";
    repo  = "yabar";
  };

  inherit patches;

  hardeningDisable = [ "format" ];

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    asciidoc
    docbook_xsl
    libxslt
    makeWrapper
    libconfig
    pango
  ];
  buildInputs = [
    cairo
    gdk-pixbuf
    libconfig
    pango
    xcbutilwm
    alsa-lib
    wirelesstools
  ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "\$(shell git describe)" "${version}" \
      --replace "a2x" "a2x --no-xmllint"
  '';

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

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

  #passthru.tests = { inherit (nixosTests) yabar; }; # nixos currently uses yabar-unstable

  meta = with lib; {
    description = "Modern and lightweight status bar for X window managers";
    homepage    = "https://github.com/geommer/yabar";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = [ ];
    mainProgram = "yabar";
  };
}
