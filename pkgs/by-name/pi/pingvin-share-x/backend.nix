{
  buildNpmPackage,
  prisma-engines_6,
  python3,
  src,
  version,
  meta,
  nodejs,
  imagesDir,
}:

buildNpmPackage {
  pname = "pingvin-share-x-backend";
  inherit src version nodejs;

  sourceRoot = "${src.name}/backend";

  strictDeps = true;
  __structuredAttrs = true;

  npmDepsHash = "sha256-waAY3mN5QZfJwqN3+ukjeaQhQDRLBwalwrsQacuIRcA=";

  postPatch = ''
    # Upstream always binds to all interfaces.
    substituteInPlace src/main.ts \
      --replace-fail 'process.env.PORT || "8080"),' 'process.env.PORT || "8080"), process.env.BACKEND_HOST,'
    substituteInPlace src/config/logo.service.ts \
      --replace-fail '"../frontend/public/img"' '"${imagesDir}"'
  '';

  nativeBuildInputs = [
    prisma-engines_6
    python3
  ];

  env = {
    CHECKPOINT_DISABLE = "1";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
  };

  preBuild = ''
    npx prisma generate
  '';

  postBuild = ''
    npx tsc prisma/seed/config.seed.ts --outDir dist/prisma/seed --rootDir prisma/seed
  '';

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-audit --no-fund
    rm -rf node_modules/@img/*musl*
    mkdir -p $out
    cp -r dist node_modules package.json prisma $out/

    runHook postInstall
  '';

  meta = meta // {
    description = "Backend of Pingvin Share X";
  };
}
