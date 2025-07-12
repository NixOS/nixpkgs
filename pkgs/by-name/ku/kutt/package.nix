{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  pkgs,
}:
buildNpmPackage (finalAttrs: {
  pname = "kutt";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "thedevs-network";
    repo = "kutt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mBfwgSTyE8qGdPLrR0w9yBgs/KL+rJ/EmepHJMpGF6Y=";
  };

  npmDepsHash = "sha256-6TCPP8CNcDfVYFt0/dkL/TZ/H2ATJJDCbx8LiGCEvsc=";

  dontNpmBuild = true;
  npmPackFlags = [ "--ignore-scripts" ];

  postInstall = ''
    makeWrapper ${lib.getExe pkgs.nodejs} $out/bin/kutt \
      --chdir $out/lib/node_modules/kutt \
      --add-flag server/server.js

    makeWrapper $out/lib/node_modules/kutt/node_modules/.bin/knex $out/bin/kutt-knex \
      --chdir $out/lib/node_modules/kutt
  '';

  meta = {
    description = "Free modern URL shortener";
    homepage = "https://kutt.it";
    license = lib.licenses.mit;
    mainProgram = "kutt";
    maintainers = with lib.maintainers; [ e0 ];
  };
})
