{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nodejs_26,
  version,
}:

buildNpmPackage (finalAttrs: {
  pname = "opengym-api";
  inherit version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DuarteSantos8";
    repo = "openGym";
    rev = "2d70e026effc6602f513555166a97443520f0572";
    hash = "sha256-YkuPELGnAfjmC/CK7SR/c2OhyP+VdLgK/O2qmDKn/Sw=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";

  npmDepsHash = "sha256-qjLSyj/CV0nSgiNLx6EzXyXEWuAmP3hwe5enfgO+pjM=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/lib/opengym-api $out/bin
    cp -r . $out/lib/opengym-api/

    makeWrapper ${nodejs_26}/bin/node $out/bin/opengym-api \
      --add-flags "$out/lib/opengym-api/server.js" \
      --set NODE_ENV production
  '';

  meta = {
    description = "openGym API — passkey auth + per-user workout data (Node.js)";
    homepage = "https://gitlab.com/DuarteSantos8/opengym";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = lib.platforms.linux;
  };
})
