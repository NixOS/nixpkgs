{
  buildNpmPackage,
  src,
  version,
  meta,
  nodejs,
  imagesDir,
}:

buildNpmPackage {
  pname = "pingvin-share-x-frontend";
  inherit src version nodejs;

  sourceRoot = "${src.name}/frontend";

  strictDeps = true;
  __structuredAttrs = true;

  npmDepsHash = "sha256-S20834EftT5we8ugTW9P16G3s8JtaqcZdhvgPoReheQ=";

  env.NEXT_TELEMETRY_DISABLED = "1";

  # Keep the bundled images for the service to seed imagesDir with, and serve
  # /img from the mutable imagesDir so uploaded logos show up.
  installPhase = ''
    runHook preInstall

    cp -r .next/standalone $out
    cp -r .next/static $out/.next/static
    cp -r public $out/public
    mv $out/public/img $out/img
    ln -s ${imagesDir} $out/public/img

    runHook postInstall
  '';

  meta = meta // {
    description = "Frontend of Pingvin Share X";
  };
}
