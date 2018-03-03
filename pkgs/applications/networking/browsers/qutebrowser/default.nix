{ stdenv, lib, fetchurl, fetchzip, python3Packages
, makeWrapper, wrapGAppsHook, qtbase, glib-networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2
, libxslt, gst_all_1 ? null
, withPdfReader        ? true
, withMediaPlayback    ? true
, withWebEngineDefault ? true
}:

assert withMediaPlayback -> gst_all_1 != null;

let
  pdfjs = stdenv.mkDerivation rec {
    name = "pdfjs-${version}";
    version = "1.7.225";

    src = fetchzip {
      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/${name}-dist.zip";
      sha256 = "0bsmbz7bbh0zpd70dlhss4fjdw7zq356091wld9s7kxnb2rixqd8";
      stripRoot = false;
    };

    buildCommand = ''
      mkdir $out
      cp -r $src $out
    '';
  };

in python3Packages.buildPythonApplication rec {
  name = "qutebrowser-${version}${versionPostfix}";
  namePrefix = "";
  version = "1.1.1";
  versionPostfix = "";

  # the release tarballs are different from the git checkout!
  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/${name}.tar.gz";
    sha256 = "09fa77rg1yrl8cksavxmgm9z2246s4d8wjbkl5jm1gsam345f7mz";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [
    qtbase
    glib-networking
  ] ++ lib.optionals withMediaPlayback (with gst_all_1; [
    gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly gst-libav
  ]) ++ lib.optional (!withWebEngineDefault) python3Packages.qtwebkit-plugins;

  nativeBuildInputs = [
    makeWrapper wrapGAppsHook asciidoc
    docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml pyqt5 jinja2 pygments
    pypeg2 cssutils pyopengl attrs
  ];

  postPatch = ''
    sed -i "s,/usr/share/qutebrowser,$out/share/qutebrowser,g" qutebrowser/utils/standarddir.py
  '' + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  '';

  postBuild = ''
    a2x -f manpage doc/qutebrowser.1.asciidoc
  '';

  postInstall = ''
    install -Dm644 doc/qutebrowser.1 "$out/share/man/man1/qutebrowser.1"
    install -Dm644 misc/qutebrowser.desktop \
        "$out/share/applications/qutebrowser.desktop"
    for i in 16 24 32 48 64 128 256 512; do
        install -Dm644 "icons/qutebrowser-''${i}x''${i}.png" \
            "$out/share/icons/hicolor/''${i}x''${i}/apps/qutebrowser.png"
    done
    install -Dm644 icons/qutebrowser.svg \
        "$out/share/icons/hicolor/scalable/apps/qutebrowser.svg"
    install -Dm755 -t "$out/share/qutebrowser/userscripts/" misc/userscripts/*
    install -Dm755 -t "$out/share/qutebrowser/scripts/" \
      scripts/{importer.py,dictcli.py,keytester.py,open_url_in_instance.sh,utils.py}
  '';

  postFixup = lib.optionalString (! withWebEngineDefault) ''
    wrapProgram $out/bin/qutebrowser --add-flags "--backend webkit"
  '';

  meta = {
    homepage = https://github.com/The-Compiler/qutebrowser;
    description = "Keyboard-focused browser with a minimal GUI";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
