{ stdenv, lib, fetchurl, unzip, buildPythonApplication, makeWrapper, wrapGAppsHook
, qtbase, pyqt5, jinja2, pygments, pyyaml, pypeg2, pyopengl, cssutils, glib_networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2, libxslt
, gst-plugins-base, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, gst-libav
, qtwebkit-plugins
, withWebEngineDefault ? false
}:

let
  pdfjs = stdenv.mkDerivation rec {
    name = "pdfjs-${version}";
    version = "1.7.225";

    src = fetchurl {
      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/${name}-dist.zip";
      sha256 = "1n8ylmv60r0qbw2vilp640a87l4lgnrsi15z3iihcs6dj1n1yy67";
    };

    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      mkdir $out
      unzip -d $out $src
    '';
  };

in buildPythonApplication rec {
  name = "qutebrowser-${version}";
  version = "0.11.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/The-Compiler/qutebrowser/releases/download/v${version}/${name}.tar.gz";
    sha256 = "13ihx66jm1dd6vx8px7pm0kbzf2sf9x43hhivc1rp17kahnxxdyv";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [
    qtbase qtwebkit-plugins
    gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
    glib_networking
  ];

  nativeBuildInputs = [
    makeWrapper wrapGAppsHook asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
  ];

  propagatedBuildInputs = [
    pyyaml pyqt5 jinja2 pygments pypeg2 cssutils pyopengl
  ];

  postPatch = ''
    sed -i "s,/usr/share/qutebrowser,$out/share/qutebrowser,g" qutebrowser/utils/standarddir.py
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  '';

  postBuild = ''
    a2x -f manpage doc/qutebrowser.1.asciidoc
  '';

  postInstall = ''
    install -Dm644 doc/qutebrowser.1 "$out/share/man/man1/qutebrowser.1"
    install -Dm644 qutebrowser.desktop \
        "$out/share/applications/qutebrowser.desktop"
    for i in 16 24 32 48 64 128 256 512; do
        install -Dm644 "icons/qutebrowser-''${i}x''${i}.png" \
            "$out/share/icons/hicolor/''${i}x''${i}/apps/qutebrowser.png"
    done
    install -Dm644 icons/qutebrowser.svg \
        "$out/share/icons/hicolor/scalable/apps/qutebrowser.svg"
    install -Dm755 -t "$out/share/qutebrowser/userscripts/" misc/userscripts/*
  '';

  postFixup = lib.optionalString withWebEngineDefault ''
    wrapProgram $out/bin/qutebrowser --add-flags "--backend webengine"
  '';

  meta = {
    homepage = "https://github.com/The-Compiler/qutebrowser";
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
