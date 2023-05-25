{ stdenv, lib, fetchurl, fetchzip, fetchFromGitHub, python3
, wrapQtAppsHook, glib-networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2
, libxslt, gst_all_1 ? null
, withPdfReader      ? true
, withMediaPlayback  ? true
, backend            ? "webengine"
, pipewireSupport    ? stdenv.isLinux
, pipewire
, qtwayland
, mkDerivationWith ? null
, qtbase ? null
, qtwebengine ? null
, wrapGAppsHook ? null
, enableWideVine ? false
, widevine-cdm
}: let
  isQt6 = mkDerivationWith == null;

  python3Packages = python3.pkgs;
  pdfjs = let
    version = "2.14.305";
  in
  fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
    hash = "sha256-E7t+0AUndrgi4zfJth0w28RmWLqLyXMUCnueNf/gNi4=";
    stripRoot = false;
  };

  backendPackage =
   if backend == "webengine" then if isQt6 then python3Packages.pyqt6-webengine else python3Packages.pyqtwebengine else
   if backend == "webkit"    then python3Packages.pyqt5_with_qtwebkit else
   throw ''
     Unknown qutebrowser backend "${backend}".
     Valid choices are qtwebengine (recommended) or qtwebkit.
   '';

  buildPythonApplication = if isQt6 then python3Packages.buildPythonApplication else mkDerivationWith python3Packages.buildPythonApplication;

  pname = "qutebrowser";
  version = if isQt6 then "unstable-2023-04-18" else "2.5.3";
in

assert withMediaPlayback -> gst_all_1 != null;
assert isQt6 -> backend != "webkit";

buildPythonApplication {
  inherit pname version;

  src = if isQt6 then
    # comes from the master branch of upstream
    # https://github.com/qutebrowser/qutebrowser/issues/7202
    # https://github.com/qutebrowser/qutebrowser/discussions/7628
    fetchFromGitHub {
      owner = "qutebrowser";
      repo = "qutebrowser";
      rev = "d4cafc0019a4a5574caa11966fc40ede89076d26";
      hash = "sha256-Ma79EPvnwmQkeXEG9aSnD/Vt1DGhK2JX9dib7uARH8M=";
    }
  # the release tarballs are different from the git checkout!
   else fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-hF7yJDTQIztUcZJae20HVhfGlLprvz6GWrgpSwLJ14E=";
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
  ]
    ++ lib.optional isQt6 python3Packages.pygments;

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
    ++ lib.optional stdenv.isLinux qtwayland
  );

  patches = [
    ./fix-restart.patch
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preConfigure = lib.optionalString isQt6 ''
    python scripts/asciidoc2html.py
  '';

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr,$out,g" qutebrowser/utils/standarddir.py
  '' + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  '';

  installPhase = ''
    runHook preInstall

    make -f misc/Makefile \
      PYTHON=${python3}/bin/python3 \
      PREFIX=. \
      DESTDIR="$out" \
      DATAROOTDIR=/share \
      install

    runHook postInstall
  '';

  postInstall = ''
    # Patch python scripts
    buildPythonPath "$out $propagatedBuildInputs"
    scripts=$(grep -rl python "$out"/share/qutebrowser/{user,}scripts/)
    for i in $scripts; do
      patchPythonScript "$i"
    done
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [ pipewire ];
  in
    ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "''${qtWrapperArgs[@]}"
      --add-flags '--backend ${backend}'
      --set QUTE_QTWEBENGINE_VERSION_OVERRIDE "${lib.getVersion qtwebengine}"
      ${lib.optionalString isQt6 ''--set QUTE_QT_WRAPPER "PyQt6"''}
      ${lib.optionalString (pipewireSupport && backend == "webengine") ''--prefix LD_LIBRARY_PATH : ${libPath}''}
      ${lib.optionalString enableWideVine ''--add-flags "--qt-flag widevine-path=${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"''}
    )
  '';

  meta = with lib; {
    homepage    = "https://github.com/qutebrowser/qutebrowser";
    description = "Keyboard-focused browser with a minimal GUI";
    license     = licenses.gpl3Plus;
    platforms   = if enableWideVine then [ "x86_64-linux" ] else backendPackage.meta.platforms;
    maintainers = with maintainers; [ jagajaga rnhmjoj ebzzry dotlambda nrdxp ];
  };
}
