{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gtksourceview5,
  webkitgtk_6_0,
  gcr_4,
  gdk-pixbuf,
  autoPatchelfHook,
  appstream,
  libxml2,
}:
python3Packages.buildPythonApplication rec {
  pname = "devtoolbox";
  version = "1.3.0";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "aleiepure";
    repo = "devtoolbox";
    tag = "v${version}";
    hash = "sha256-ReF70pNMrMweEB4WAGQT++9TxTN4gV1olln7Y6YWCis=";
  };

  # test after update
  postPatch = ''
    substituteInPlace src/views/reverse_cron.py \
      --replace-fail '"\D"' 'r"\D"'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    autoPatchelfHook
    appstream
    libxml2
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    webkitgtk_6_0
    gcr_4
    gdk-pixbuf
  ];

  dependencies = with python3Packages; [
    pygobject3
    ruamel-yaml
    lxml
    python-crontab
    jwt
    jsonschema
    pytz
    tzlocal
    python-lorem
    uuid6
    textstat
    markdown2
    daltonlens
    asn1crypto
    qrcode
    sqlparse
    jsbeautifier
    cssbeautifier
    humanize
    croniter
    python-dateutil
    rcssmin
    rjsmin
    cryptography
    color-parser-py
  ];

  dontWrapGApps = true;

  # Contains an unusable devtoolbox-run-script
  postInstall = ''
    rm -r $out/devtoolbox
    ln -s $out/share/locale/zh_Hant $out/share/locale/zh_TW
    ln -s $out/share/locale/zh_Hans $out/share/locale/zh_CN
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Development tools at your fingertips";
    longDescription = ''
      If you're tired of endlessly looking online for the right
      tool, or to find again that website of which you don't
      recall the name to do a quick conversion, this is the
      right app for you. This is a collection of powerful yet
      simple-to-use tools and utilities to solve the most common
      daily development problems:
      - JSON to YAML converter and vice-versa
      - CRON expressions parser
      - Formatters for common languages
      - Hash generators
      - Regex tester
      - Markdown Previewer
      - Image converters
      - Much more...
    '';
    homepage = "https://github.com/aleiepure/devtoolbox";
    license = with lib.licenses; [
      gpl3Plus
      cc0
      lgpl3Only
      mit
      unlicense
    ];
    mainProgram = "devtoolbox";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
