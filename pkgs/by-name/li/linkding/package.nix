{ callPackage
, nixosTests
, python3
,
}:
let
  python = python3;

  common = callPackage ./common.nix { };

  frontend = callPackage ./frontend.nix { };
in
python.pkgs.pythonPackages.buildPythonPackage {
  pname = "linkding";

  inherit (common) version src;

  format = "other";

  NODE_PATH = "${frontend}/node_modules";

  propagatedBuildInputs = with python.pkgs; [
    beautifulsoup4
    bleach
    bleach-allowlist
    django
    django-registration
    django-sass-processor
    django-widget-tweaks
    djangorestframework
    huey
    markdown
    mozilla-django-oidc
    psycopg2
    python-dateutil
    pytz
    requests
    soupsieve
    typing-extensions
    waybackpy
  ];

  postPatch = ''
    rm siteroot/settings/dev.py
  '';

  configurePhase = ''
    runHook preConfigure

    ln -sf "${frontend}/node_modules/" node_modules
    ln -sf "${frontend}/bookmarks/static/bundle.js" bookmarks/static/bundle.js
    ln -sf "${frontend}/bookmarks/static/bundle.js.map" bookmarks/static/bundle.js.map

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Avoid dependency on django debug toolbar
    export DEBUG=

    mkdir -p data/favicons

    ${python.pythonOnBuildForHost.interpreter} manage.py compilescss
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --ignore=*.scss
    ${python.pythonOnBuildForHost.interpreter} manage.py compilescss --delete-files

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/linkding
    chmod +x $out/lib/linkding/manage.py
    makeWrapper $out/lib/linkding/manage.py $out/bin/linkding --prefix PYTHONPATH : "$PYTHONPATH"

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    ${python.pythonOnBuildForHost.interpreter} manage.py test

    runHook postCheck
  '';

  passthru = {
    inherit frontend python;

    updateScript = ./update.sh;

    tests = {
      inherit (nixosTests) linkding;
    };
  };

  meta =
    common.meta
    // {
      description = ''
        Self-hosted bookmark manager that is designed be to be minimal, fast, and easy to set up using Docker.
      '';
    };
}
