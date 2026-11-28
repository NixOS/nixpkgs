{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkgs,
}:

buildGoModule rec {
  pname = "maputnik";
  version = "2.1.1";
  maputnikSrc = fetchFromGitHub {
    owner = "maplibre";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rrrRX+W1OQ16ss11x1qFWBxoQBOiOUlL5lQfGUMkVU0=";
  };
  src = "${maputnikSrc}/desktop";
  vendorHash = "sha256-UPYpYEY2fdez5o2uYdjWAfA8A4DyA88K7sIPEUFQzyw=";

  maputnikNpm = buildNpmPackage rec {
    inherit pname version;
    src = maputnikSrc;

    npmDepsHash = "sha256-I4rgk3RKCtEQvzwlzCrBdim9xlilciIuOqxhqlNyaFc=";
    npmFlags = [ "--legacy-peer-deps" ];
    dontNpmBuild = true;
    makeCacheWritable = true;

    patches = [ ./no-cypress.patch ];

    buildPhase = "./node_modules/vite/bin/vite.js build --base=/ --outDir=editor";
    installPhase = "mkdir -p $out/lib && cp -r editor $out/lib/";
  };

  nativeBuildInputs = [ pkgs.go-rice ];

  # TODO: DesktopVersion removed in master
  versionGo = pkgs.writeText "version.go" ''
    package main

    const DesktopVersion = "1.1.1"
    const EditorVersion = "${version}"
  '';

  preConfigure = ''
    cp ${versionGo} version.go
    cp -r ${maputnikNpm}/lib/editor .
    rice embed-go
  '';

  postInstall = "mv $out/bin/desktop $out/bin/maputnik";

  meta = {
    description = "An open source visual editor for the 'MapLibre Style Specification'";
    homepage = "https://github.com/maplibre/maputnik/wiki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ starsep ];
  };
}
