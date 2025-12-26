{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
}:
let
  name = "chartdb";
  version = "1.19.0"; # https://github.com/chartdb/chartdb/releases
in
buildNpmPackage {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = name;
    repo = name;
    rev = "v${version}";
    hash = "sha256-vRnxvX86K0Nm+h/jWN1YRJXknYsq3nBhpxRA12m9kfU=";
  };

  nodejs = nodejs_24; # https://github.com/chartdb/chartdb/blob/fb19a7ac2f8e5270c1c1dfdc0e32e5004327bc68/package.json#L88

  npmDepsHash = "sha256-7W8s+8wkw4ULmrs3dO7+HZcrQh9szU5TeMPbJGHq3Lo=";

  NODE_OPTIONS = "--max-old-space-size=4096"; # Increase heap size to prevent OOM during the Vite build/minification phase

  VITE_HIDE_CHARTDB_CLOUD = "true"; # See https://github.com/search?type=code&q=repo:chartdb/chartdb+HIDE_CHARTDB_CLOUD

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${name}
    cp -r dist/* $out/share/${name}

    runHook postInstall
  '';

  meta = {
    description = "Open-source database diagrams editor";
    longDescription = "Database diagrams editor that allows you to visualize and design your DB with a single query";
    homepage = "https://${name}.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      malix
    ];
    platforms = lib.platforms.all;
  };
}
