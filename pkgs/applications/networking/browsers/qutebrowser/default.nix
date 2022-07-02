{ stdenv, lib, fetchurl, fetchzip, python3
, mkDerivationWith, wrapQtAppsHook, wrapGAppsHook, qtbase, qtwebengine, glib-networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2
, libxslt, gst_all_1 ? null
, withPdfReader      ? true
, withMediaPlayback  ? true
, backend            ? "webengine"
, pipewireSupport    ? stdenv.isLinux
, pipewire_0_2
}:

assert withMediaPlayback -> gst_all_1 != null;

let
  python3Packages = python3.pkgs;
  pdfjs = let
    version = "2.14.305";
  in
  fetchzip rec {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
    hash = "sha256-E7t+0AUndrgi4zfJth0w28RmWLqLyXMUCnueNf/gNi4=";
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
  version = "2.5.2";

  # the release tarballs are different from the git checkout!
  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-qb/OFN3EA94N6y7t+YPCMc4APgdZmV7H706jTkl06Qg=";
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

  propagatedBuildInputs = with python3Packages; ([
    pyyaml backendPackage jinja2 pygments
    # scripts and userscripts libs
    tldextract beautifulsoup4
    readability-lxml pykeepass stem
    pynacl
    # extensive ad blocking
    adblock
  ]
    ++ lib.optional (pythonOlder "3.9") importlib-resources
  );

  patches = [
    ./fix-restart.patch
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr,$out,g" qutebrowser/utils/standarddir.py
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

  preFixup = let
    libPath = lib.makeLibraryPath [ pipewire_0_2 ];
  in
    ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
      --add-flags '--backend ${backend}'
      --set QUTE_QTWEBENGINE_VERSION_OVERRIDE "${lib.getVersion qtwebengine}"
      ${lib.optionalString (pipewireSupport && backend == "webengine") ''--prefix LD_LIBRARY_PATH : ${libPath}''}
    )
  '';

  meta = with lib; {
    homepage    = "https://github.com/The-Compiler/qutebrowser";
    description = "Keyboard-focused browser with a minimal GUI";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ jagajaga rnhmjoj ebzzry dotlambda ];
    inherit (backendPackage.meta) platforms;
  };
}
