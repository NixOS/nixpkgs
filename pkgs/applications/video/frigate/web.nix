{ buildNpmPackage
, src
, version
}:

buildNpmPackage {
  pname = "frigate-web";
  inherit version src;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace package.json \
      --replace "--base=/BASE_PATH/" ""

    substituteInPlace src/routes/Storage.jsx \
      --replace "/media/frigate" "/var/lib/frigate" \
      --replace "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-fvRxpQjSEzd2CnoEOVgQcB6MJJ4dcjN8bOaacHjCdwU=";

  installPhase = ''
    cp -rv dist/ $out
  '';
}
