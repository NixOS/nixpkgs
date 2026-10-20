{
  lib,
  stdenv,
  fetchFromGitHub,
  swift,
  swiftpm,
  fetchSwiftPMDeps,
  apple-sdk_15,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pfw";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "pointfreeco";
    repo = "pfw";
    tag = finalAttrs.version;
    hash = "sha256-BVgWLK1K9g9sQlZGkDkDVFNDsSlW6Ab8DCQCXSAGpzY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    apple-sdk_15
    (darwinMinVersionHook "15.0")
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-89BAnL+CTZtVEYqk6EXTgtpsF/LwunnY4wOkbAjwmhs=";
  };

  swiftpmFlags = [
    "--product"
    "pfw"
  ];

  installPhase = ''
    runHook preInstall

    install -D "$(swiftpmBinPath)/pfw" "$out/bin/pfw"

    runHook postInstall
  '';

  meta = {
    description = "CLI for managing Point-Free Way skills";
    homepage = "https://github.com/pointfreeco/pfw";
    changelog = "https://github.com/pointfreeco/pfw/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shgew ];
    platforms = lib.platforms.darwin;
    mainProgram = "pfw";
  };
})
