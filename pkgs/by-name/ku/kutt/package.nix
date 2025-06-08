{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  pkg-config,
  python3,
  stdenv,
  nodejs_22,
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

  meta = {
    description = "Free modern URL shortener";
    homepage = "https://kutt.it";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ e0 ];
  };
})
