{
  buildNpmPackage,

  libsecret,
  python3,
  pkg-config,

  pname,
  src,
  version,
}:
buildNpmPackage {
  pname = "${pname}-node-deps";
  inherit version src;

  npmDepsHash = "sha256-fMKGi+AJTMlWl7SQtZ21hUwOLgqlFYDhwLvEergQLfI=";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [ libsecret ];

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r node_modules $out/lib

    runHook postInstall
  '';
}
