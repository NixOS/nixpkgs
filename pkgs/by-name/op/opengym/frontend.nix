{
  buildNpmPackage,
  src,
  version,
  pkg-config,
  python3,
  vips,
}:

buildNpmPackage {
  pname = "opengym-frontend";
  inherit version src;

  sourceRoot = "${src.name}/frontend";
  npmDepsHash = "sha256-Kc4Jccd5JQPCqiomqCZjkDc88p0VnCU1xxjDnEOK9rQ=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = [ vips ];

  buildPhase = ''
    npm run build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/exercise-media
    cp -R dist/* $out/

    cp -R ../catalogue/media/* $out/exercise-media/

    runHook postInstall
  '';
}
