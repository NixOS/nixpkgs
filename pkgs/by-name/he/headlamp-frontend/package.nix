{
  buildNpmPackage,
  headlamp-server,
}:

buildNpmPackage {
  pname = "headlamp-frontend";
  inherit (headlamp-server) version src;

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${headlamp-server.src.name}/frontend";

  npmDepsHash = "sha256-73xc/GK1Cvz67D6ftYVRe5GARNgG5qD86CGK6uhoyWA=";

  postPatch = ''
    chmod -R u+w ../app
    cp ${headlamp-server.src}/app/package.json ../app/package.json
    substituteInPlace package.json --replace-fail '"prebuild": "npm run make-version",' ""
  '';

  preBuild = ''
    cat > .env <<EOF
    REACT_APP_HEADLAMP_VERSION=${headlamp-server.version}
    REACT_APP_HEADLAMP_GIT_VERSION=v${headlamp-server.version}
    REACT_APP_HEADLAMP_PRODUCT_NAME=Headlamp
    REACT_APP_ENABLE_REACT_QUERY_DEVTOOLS=false
    REACT_APP_HEADLAMP_SIDEBAR_DEFAULT_OPEN=true
    EOF
  '';

  env = {
    PUBLIC_URL = "./";
    NODE_OPTIONS = "--max-old-space-size=8096";
  };

  installPhase = ''
    runHook preInstall
    cp -r build $out
    runHook postInstall
  '';

  meta = {
    inherit (headlamp-server.meta)
      description
      homepage
      changelog
      license
      maintainers
      ;
  };
}
