{
  buildNpmPackage,
  src,
  version,
}:

buildNpmPackage {
  pname = "frigate-web";
  inherit version src;

  sourceRoot = "${src.name}/web";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "--base=/BASE_PATH/" ""

    substituteInPlace src/routes/Storage.jsx \
      --replace-fail "/media/frigate" "/var/lib/frigate" \
      --replace-fail "/tmp/cache" "/var/cache/frigate"
  '';

  npmDepsHash = "sha256-+36quezGArqIM9dM+UihwcIgmE3EVmJQThuicLgDW4A=";

  installPhase = ''
    cp -rv dist/ $out
  '';
}
