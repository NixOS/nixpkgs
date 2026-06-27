{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rh";
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "reason-healthcare";
    repo = "rh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XpAAkjPNtcirEIm772jth3vu9h9Rjr/zcZ83EvxylME=";
  };

  cargoHash = "sha256-8yR1nb6aJ9DrgN3DP/bSZjWTo5luskS/QgxNG35zIgM=";

  cargoBuildFlags = [
    "-p"
    "rh-cli"
  ];
  cargoTestFlags = [
    "-p"
    "rh-cli"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "High-performance FHIR toolkit and CLI written in Rust";
    longDescription = ''
      Rust Health (rh) is a modern, high-performance toolkit for working with
      HL7® FHIR®, purpose-built in Rust. Ships as a cross-platform CLI, Rust
      library crates, and WebAssembly-backed npm packages.

      Features include:
      - FHIR resource validation
      - FHIRPath expression evaluation
      - FHIR Shorthand (FSH) compilation
      - CQL to ELM translation
      - FHIR package management
      - VCL (Value Set Composition Language) support
    '';
    homepage = "https://github.com/reason-healthcare/rh";
    changelog = "https://github.com/reason-healthcare/rh/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ bkaney ];
    mainProgram = "rh";
    platforms = lib.platforms.all;
  };
})
