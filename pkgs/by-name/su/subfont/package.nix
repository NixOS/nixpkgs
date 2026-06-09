{
  lib,
  buildNpmPackage,
  cairo,
  fetchurl,
  nodejs_22,
  pango,
  pixman,
  pkg-config,
  testers,
}:

let
  pname = "subfont";
  version = "7.2.3";
  src = fetchurl {
    url = "https://registry.npmjs.org/subfont/-/subfont-${version}.tgz";
    hash = "sha256-daHPt03dPBCWYXFS8x1SNTRlkmCCdWmmondur6fRBgY=";
  };
in
buildNpmPackage (finalAttrs: {
  inherit pname version src;

  nodejs = nodejs_22;

  npmDepsHash = "sha256-ocCVdUtKiWNVzxZljcb2Y+4u3r34drbcNyfKT3Rj1mY=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    pango
    pixman
  ];

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Command line tool to optimize webfont loading by aggressively subsetting based on font use, self-hosting of Google fonts and preloading";
    mainProgram = "subfont";
    homepage = "https://github.com/Munter/subfont";
    changelog = "https://github.com/Munter/subfont/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
