{
  lib,
  buildNpmPackage,

  stdenv,
  libsecret,
  python3,
  pkg-config,
  clang_20,

  pname,
  src,
  version,
}:
buildNpmPackage {
  pname = "${pname}-node-deps";
  inherit version src;

  npmDepsHash = "sha256-TCeIBrlsNuphW2gVsX97+Wu1lOG5gDwS7559YA1d10M=";

  nativeBuildInputs = [
    python3
    pkg-config
  ]
  ++ lib.optionals stdenv.isDarwin [ clang_20 ]; # clang_21 breaks keytar

  buildInputs = [ libsecret ];

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r node_modules $out/lib

    runHook postInstall
  '';
}
