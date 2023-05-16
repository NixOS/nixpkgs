<<<<<<< HEAD
{ stdenv, lib, fetchurl, fetchzip, python3
=======
{ stdenv, lib, fetchurl, fetchzip, fetchFromGitHub, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapQtAppsHook, glib-networking
, asciidoc, docbook_xml_dtd_45, docbook_xsl, libxml2
, libxslt, gst_all_1 ? null
, withPdfReader      ? true
, withMediaPlayback  ? true
, backend            ? "webengine"
, pipewireSupport    ? stdenv.isLinux
, pipewire
, qtwayland
<<<<<<< HEAD
, qtbase
, qtwebengine
, wrapGAppsHook
, enableWideVine ? false
, widevine-cdm
}:

let
  pdfjs = let
    version = "3.9.179";
  in
  fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
    hash = "sha256-QoJFb7MlZN6lDe2Yalsd10sseukL6+tNRi6JzLPVBYw=";
    stripRoot = false;
  };

  pname = "qutebrowser";
  version = "3.0.0";
in

assert withMediaPlayback -> gst_all_1 != null;
assert lib.assertMsg (backend != "webkit") ''
  Support for the QtWebKit backend has been removed.
  Please remove the `backend = "webkit"` option from your qutebrowser override.
'';

python3.pkgs.buildPythonApplication {
  inherit pname version;
  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-Oer0p/DwUfOejUCgSCSkMvLLAjNyJx51qgN7bcQQ2Pw=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    python3.pkgs.pygments
  ];

  propagatedBuildInputs = with python3.pkgs; ([
    pyyaml pyqt6-webengine jinja2 pygments
=======
  ]
    ++ lib.optional isQt6 python3Packages.pygments;

  propagatedBuildInputs = with python3Packages; ([
    pyyaml backendPackage jinja2 pygments
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # scripts and userscripts libs
    tldextract beautifulsoup4
    readability-lxml pykeepass stem
    pynacl
    # extensive ad blocking
    adblock
<<<<<<< HEAD
  ] ++ lib.optional stdenv.isLinux qtwayland
=======
  ]
    ++ lib.optional (pythonOlder "3.9") importlib-resources
    ++ lib.optional stdenv.isLinux qtwayland
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  );

  patches = [
    ./fix-restart.patch
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

<<<<<<< HEAD
=======
  preConfigure = lib.optionalString isQt6 ''
    python scripts/asciidoc2html.py
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      ${lib.optionalString pipewireSupport ''--prefix LD_LIBRARY_PATH : ${libPath}''}
=======
      --add-flags '--backend ${backend}'
      --set QUTE_QTWEBENGINE_VERSION_OVERRIDE "${lib.getVersion qtwebengine}"
      ${lib.optionalString isQt6 ''--set QUTE_QT_WRAPPER "PyQt6"''}
      ${lib.optionalString (pipewireSupport && backend == "webengine") ''--prefix LD_LIBRARY_PATH : ${libPath}''}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      ${lib.optionalString enableWideVine ''--add-flags "--qt-flag widevine-path=${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"''}
    )
  '';

  meta = with lib; {
    homepage    = "https://github.com/qutebrowser/qutebrowser";
    description = "Keyboard-focused browser with a minimal GUI";
    license     = licenses.gpl3Plus;
<<<<<<< HEAD
    platforms   = if enableWideVine then [ "x86_64-linux" ] else qtwebengine.meta.platforms;
=======
    platforms   = if enableWideVine then [ "x86_64-linux" ] else backendPackage.meta.platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ jagajaga rnhmjoj ebzzry dotlambda nrdxp ];
  };
}
