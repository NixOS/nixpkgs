{
  lib,
  buildNpmPackage,
  fetchFromSourcehut,
  fetchpatch,
  gobject-introspection,
  gst_all_1,
  poppler-utils,
  python3,
  xorg,
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      celery = prev.celery.overridePythonAttrs {
        doCheck = false;
      };

      kombu = prev.kombu.overridePythonAttrs {
        # avoid conflicts with test only dependencies
        doCheck = false;
      };

      sqlalchemy = prev.sqlalchemy_1_4;
    };
  };

  version = "0.14.0";
  src = fetchFromSourcehut {
    owner = "~mediagoblin";
    repo = "mediagoblin";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Y1VnXLHEl6TR8nt+vKSfoCwleQ+oA2WPMN9q4fW9R3s=";
  };

  patches = [
    (fetchpatch {
      url = "https://git.sr.ht/~mediagoblin/mediagoblin/commit/95a591bb2ffdeed059b926059155fd0802e6b1e6.patch";
      excludes = [ "docs/source/siteadmin/relnotes.rst" ];
      hash = "sha256-Coff02bewl6E9bHeMy/6tA2dngKcw/c33xk9nmMl/Bk=";
    })
  ];

  extlib = buildNpmPackage {
    name = "mediagoblin-extlib";
    inherit src patches;

    npmDepsHash = "sha256-wtk5MgsWEpuz3V/EcozEAMOa8UeCgdjhR5wxaiaMugY=";

    dontNpmBuild = true;

    installPhase = ''
      mkdir -p $out/node_modules/
      cp -r node_modules/{jquery,video.js,videojs-resolution-switcher,leaflet} $out/node_modules/
    '';
  };
in
python.pkgs.buildPythonApplication rec {
  format = "setuptools";
  pname = "mediagoblin";
  inherit version src patches;

  postPatch = ''
    # https://git.sr.ht/~mediagoblin/mediagoblin/tree/bf61d38df21748aadb480c53fdd928647285e35f/item/.guix/modules/mediagoblin-package.scm#L60-62
    cp mediagoblin/_version.py.in mediagoblin/_version.py
    substituteInPlace mediagoblin/_version.py \
      --replace-fail "@PACKAGE_VERSION@" "${version}"

    # https://git.sr.ht/~mediagoblin/mediagoblin/tree/bf61d38df21748aadb480c53fdd928647285e35f/item/.guix/modules/mediagoblin-package.scm#L66-67
    substituteInPlace mediagoblin/gmg_commands/__init__.py \
      --replace-fail "ArgumentParser(" "ArgumentParser(prog=\"gmg\","
  '';

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.babel
    xorg.lndir
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    alembic
    babel
    bcrypt
    celery
    certifi
    configobj
    email-validator
    exifread
    feedgenerator
    itsdangerous
    jinja2
    jsonschema
    lxml-html-clean
    markdown
    oauthlib
    pastescript
    pillow
    pyld
    python-dateutil
    requests
    soundfile
    sqlalchemy
    unidecode
    waitress
    werkzeug
    wtforms
    wtforms-sqlalchemy

    # undocumented and fails to start without
    gst-python
    pygobject3
  ];

  optional-dependencies =
    with python.pkgs;
    let
      # not really documented in python build system
      gst = with gst_all_1; [
        # https://git.sr.ht/~mediagoblin/mediagoblin/tree/bf61d38df21748aadb480c53fdd928647285e35f/item/.guix/modules/mediagoblin-package.scm#L122-127
        gst-libav
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
        gstreamer
      ];
    in
    {
      ascii = [ chardet ];
      audio = [ numpy ] ++ gst;
      ldap = [ python-ldap ];
      openid = [ python3-openid ];
      raw_image = [ py3exiv2 ];
      video = [ pygobject3 ] ++ gst;
    };

  postBuild = ''
    ./devtools/compile_translations.sh
  '';

  postInstall = ''
    lndir -silent ${extlib}/node_modules $out/${python.sitePackages}/mediagoblin/static/extlib/

    ln -rs $out/${python.sitePackages}/mediagoblin/static/extlib/jquery/dist/jquery.js $out/${python.sitePackages}/mediagoblin/static/js/extlib/jquery.js
    ln -rs $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/dist/leaflet.css $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/leaflet.css
    ln -rs $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/dist/leaflet.js $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/leaflet.js
    ln -rs $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/dist/images/ $out/${python.sitePackages}/mediagoblin/static/extlib/leaflet/
  '';

  nativeCheckInputs =
    with python.pkgs;
    [
      pytest-forked
      pytest-xdist
      pytestCheckHook
      webtest

      poppler-utils
    ]
    ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "mediagoblin" ];

  passthru = {
    inherit extlib python;
  };

  meta = {
    description = "Free software media publishing platform that anyone can run";
    homepage = "https://mediagoblin.org/";
    license = lib.licenses.agpl3Plus;
    teams = [ lib.teams.c3d2 ];
  };
}
