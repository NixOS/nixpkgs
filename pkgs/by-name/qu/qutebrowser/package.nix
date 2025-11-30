{
  stdenv,
  lib,
  fetchurl,
  fetchzip,
  python3,
  glib-networking,
  asciidoc,
  docbook_xml_dtd_45,
  docbook_xsl,
  desktopToDarwinBundle,
  libxml2,
  libxslt,
  withPdfReader ? true,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pipewire,
  qt6Packages,
  wayland,
  enableWideVine ? false,
  widevine-cdm,
  # can cause issues on some graphics chips
  enableVulkan ? false,
  vulkan-loader,
}:
let
  isQt6 = lib.versions.major qt6Packages.qtbase.version == "6";
  pdfjs =
    let
      version = "5.4.394";
    in
    fetchzip {
      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
      hash = "sha256-KMpSwF5MmoWdNoIUd4ZOwbJZZmjkid8wUoFKw7XjQFA=";
      stripRoot = false;
    };

  version = "3.6.2";
in
python3.pkgs.buildPythonApplication {
  pname = "qutebrowser" + lib.optionalString (!isQt6) "-qt5";
  inherit version;
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/qutebrowser/qutebrowser/releases/download/v${version}/qutebrowser-${version}.tar.gz";
    hash = "sha256-GfSkVluSwcCAvLPlW49QLmyWblTrnW9Qgqne0Qy8JJM=";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [
    qt6Packages.qtbase
    glib-networking
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6Packages.qtwayland
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  dependencies = with python3.pkgs; [
    colorama
    pyyaml
    (if isQt6 then pyqt6-webengine else pyqtwebengine)
    jinja2
    pygments
    # scripts and userscripts libs
    tldextract
    beautifulsoup4
    readability-lxml
    pykeepass
    stem
    pynacl
    # extensive ad blocking
    adblock
    # for the qute-bitwarden user script to be able to copy the TOTP token to clipboard
    pyperclip
  ];

  patches = [
    ./fix-restart.patch
  ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr,$out,g" qutebrowser/utils/standarddir.py
  ''
  + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  ''
  + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform wayland) ''
    substituteInPlace qutebrowser/misc/wmname.py \
      --replace-fail '_load_library("wayland-client")' \
                     'ctypes.CDLL("${lib.getLib wayland}/lib/libwayland-client${stdenv.hostPlatform.extensions.sharedLibrary}")'
  '';

  installPhase = ''
    runHook preInstall

    make -f misc/Makefile \
      PYTHON=${(python3.pythonOnBuildForHost.withPackages (ps: with ps; [ setuptools ])).interpreter} \
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

  preFixup =
    let
      libPath = lib.makeLibraryPath [ pipewire ];
      resourcesPath =
        if (isQt6 && stdenv.hostPlatform.isDarwin) then
          "${qt6Packages.qtwebengine}/lib/QtWebEngineCore.framework/Resources"
        else
          "${qt6Packages.qtwebengine}/resources";
    in
    ''
      makeWrapperArgs+=(
        # Force the app to use QT_PLUGIN_PATH values from wrapper
        --unset QT_PLUGIN_PATH
        "''${qtWrapperArgs[@]}"
        # avoid persistant warning on starup
        --set QT_STYLE_OVERRIDE Fusion
        ${lib.optionalString pipewireSupport ''--prefix LD_LIBRARY_PATH : ${libPath}''}
        ${lib.optionalString enableVulkan ''
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
          --set-default QSG_RHI_BACKEND vulkan
        ''}
        ${lib.optionalString enableWideVine ''--add-flags "--qt-flag widevine-path=${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"''}
        --set QTWEBENGINE_RESOURCES_PATH "${resourcesPath}"
      )
    '';

  # `fixupPhase` uses `desktopToDarwinBundle` to generate an app bundle
  # (qutebrowser.app) from the qutebrowser XDG Desktop specification
  # file (./misc/org.qutebrowser.qutebrowser.desktop). Because
  # `desktopToDarwinBundle` doesn't use the MIME metadata from the .desktop
  # file, it does not generate necessary keys in Info.plist for qutebrowser to
  # be recognized by MacOS  as a valid browser.
  #
  # This phase adds those keys.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    python3 ${./patch-bundle-info.py} "$out/Applications/qutebrowser.app/Contents/Info.plist"
  '';

  meta = {
    homepage = "https://github.com/qutebrowser/qutebrowser";
    changelog = "https://github.com/qutebrowser/qutebrowser/blob/v${version}/doc/changelog.asciidoc";
    description = "Keyboard-focused browser with a minimal GUI";
    license = lib.licenses.gpl3Plus;
    mainProgram = "qutebrowser";
    platforms = if enableWideVine then [ "x86_64-linux" ] else qt6Packages.qtwebengine.meta.platforms;
    maintainers = with lib.maintainers; [
      jagajaga
      rnhmjoj
      ebzzry
      dotlambda
    ];
  };
}
