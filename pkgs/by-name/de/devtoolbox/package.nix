{ lib
, python3Packages
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, blueprint-compiler
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
, gtksourceview5
, webkitgtk_6_0
, gcr_4
, gdk-pixbuf
}:

python3Packages.buildPythonApplication rec {
  pname = "devtoolbox";
  version = "1.1.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "aleiepure";
    repo = "devtoolbox";
    rev = "v${version}";
    hash = "sha256-QFGEA+VhhRlvcch2AJrEzvRJGCSqtvZdMXWUvdAGkoU=";
  };

  # Upstream is using an incompatible version of ruamel.yaml
  # May be removed in next update
  patches = [ ./incompatible_ruamel_yaml.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    webkitgtk_6_0
    gcr_4
    gdk-pixbuf
  ];

  propagatedBuildInputs = with python3Packages; [
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
  ];

  dontWrapGApps = true;

  # Contains an unusable devtoolbox-run-script
  postInstall = ''
    rm -r $out/devtoolbox
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
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
    license = with licenses; [
      gpl3Plus
      cc0
      lgpl3Only
      mit
      unlicense
    ];
    mainProgram = "devtoolbox";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux; # webkitgtk_6_0 is broken on darwin
  };
}
