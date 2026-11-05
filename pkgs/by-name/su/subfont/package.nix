{
  lib,
  buildNpmPackage,
  cairo,
  fetchurl,
  pango,
  pixman,
  pkg-config,
  testers,
}:

let
  pname = "subfont";
  version = "7.3.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/subfont/-/subfont-${version}.tgz";
    hash = "sha256-5KqHn6jo6X8AHWQj/tkn+JSzRqvKQgRGr/rnumQWZ3o=";
  };
in
buildNpmPackage (finalAttrs: {
  inherit pname version src;

  npmDepsHash = "sha256-42vpBfy6GTQPNtJYQYr893tFluV+1uLmA9G4ekf2wqc=";

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
