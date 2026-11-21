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
  npmDepsHash = "sha256-P2gpYiwVSEVkVzYxf1l5OfYxrj/w+muJh5itfvkwLgg=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];
  buildInputs = [ vips ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R dist/* $out/

    runHook postInstall
  '';
}
