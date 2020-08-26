{ stdenv, lib, fetchurl, fetchzip, python3Packages
, mkDerivationWith, wrapQtAppsHook, wrapGAppsHook, qtbase, glib-networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2
, libxslt, gst_all_1 ? null
, withPdfReader      ? true
, withMediaPlayback  ? true
, backend            ? "webengine"
}:

assert withMediaPlayback -> gst_all_1 != null;

let
  pdfjs = let
    version = "2.4.456";
  in
  fetchzip rec {
    name = "pdfjs-${version}";
    url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/${name}-dist.zip";
    sha256 = "02hpy96pi06gdq2s7n56ycm34d6d3gf8ly22y366np5vpwmc29rx";
    stripRoot = false;
  };

  backendPackage =
   if backend == "webengine" then python3Packages.pyqtwebengine else
   if backend == "webkit"    then python3Packages.pyqt5_with_qtwebkit else
   throw ''
     Unknown qutebrowser backend "${backend}".
     Valid choices are qtwebengine (recommended) or qtwebkit.
   '';

in mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "qutebrowser";
  version = "1.13.1";

  # the release tarballs are different from the git checkout!
  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1n72dvrv4dch4i07lsis76p7g16a039fwx8rk7w8q9f60wgqb5i8";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [
    qtbase
    glib-networking
  ] ++ lib.optionals withMediaPlayback (with gst_all_1; [
    gst-plugins-base gst-plugins-good
    gst-plugins-bad gst-plugins-ugly gst-libav
  ]);

  nativeBuildInputs = [
    wrapQtAppsHook wrapGAppsHook asciidoc
    docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml backendPackage jinja2 pygments
    pypeg2 cssutils pyopengl attrs setuptools
    # scripts and userscripts libs
    tldextract beautifulsoup4
    pyreadability pykeepass stem
  ];

  patches = [ ./fix-restart.patch ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr/share/,$out/share/,g" qutebrowser/utils/standarddir.py
  '' + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  '';

  postBuild = ''
    a2x -f manpage doc/qutebrowser.1.asciidoc
  '';

  postInstall = ''
    install -Dm644 doc/qutebrowser.1 "$out/share/man/man1/qutebrowser.1"
    install -Dm644 misc/org.qutebrowser.qutebrowser.desktop \
        "$out/share/applications/org.qutebrowser.qutebrowser.desktop"

    # Install icons
    for i in 16 24 32 48 64 128 256 512; do
        install -Dm644 "icons/qutebrowser-''${i}x''${i}.png" \
            "$out/share/icons/hicolor/''${i}x''${i}/apps/qutebrowser.png"
    done
    install -Dm644 icons/qutebrowser.svg \
        "$out/share/icons/hicolor/scalable/apps/qutebrowser.svg"

    # Install scripts
    sed -i "s,/usr/bin/,$out/bin/,g" scripts/open_url_in_instance.sh
    install -Dm755 -t "$out/share/qutebrowser/scripts/" $(find scripts -type f)
    install -Dm755 -t "$out/share/qutebrowser/userscripts/" misc/userscripts/*

    # Patch python scripts
    buildPythonPath "$out $propagatedBuildInputs"
    scripts=$(grep -rl python "$out"/share/qutebrowser/{user,}scripts/)
    for i in $scripts; do
      patchPythonScript "$i"
    done
  '';

  postFixup = ''
    wrapProgram $out/bin/qutebrowser \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --add-flags '--backend ${backend}'
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/The-Compiler/qutebrowser";
    description = "Keyboard-focused browser with a minimal GUI";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ jagajaga rnhmjoj ebzzry ];
  };
}
