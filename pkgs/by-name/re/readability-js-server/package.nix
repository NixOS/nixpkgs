{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "readability-js-server";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "phpdocker-io";
    repo = "readability-js-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Pg6SCKCJttrxjqQfrUHIrWRg0LhPO+76yLsDG/YZmo=";
  };

  npmDepsHash = "sha256-VYupkbV8XEnc9DjH+h9twJFhFCp9ulo4X2tnQxkDsLY=";

  dontNpmBuild = true;

  # A root Makefile exists (for the Helm chart under charts/), so stdenv's
  # default buildPhase runs `make`'s first target - which chains into
  # `helm-verify`, requiring a `helm` binary that isn't in the sandbox.
  # There's nothing to actually build here (plain JS, no bundler), so no-op.
  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    local -r packageOut="$out/lib/node_modules/readability-js-server"
    mkdir -p "$packageOut"
    cp -r src package.json node_modules "$packageOut/"

    makeWrapper '${lib.getExe' nodejs "node"}' "$out/bin/readability-js-server" \
      --add-flags "$packageOut/src/server.js" \
      --chdir "$packageOut"

    runHook postInstall
  '';

  meta = {
    description = "Mozilla's Readability.js (Firefox Reader View engine) wrapped as an HTTP service";
    homepage = "https://github.com/phpdocker-io/readability-js-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ manfredmacx ];
    mainProgram = "readability-js-server";
  };
})
