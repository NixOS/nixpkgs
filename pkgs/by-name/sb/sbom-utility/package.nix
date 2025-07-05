{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  installShellFiles,
  stdenv,
}:

let
  version = "0.17.0";
in
buildGoModule {
  pname = "sbom-utility";
  inherit version;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "sbom-utility";
    tag = "v${version}";
    hash = "sha256-LiHCA5q9IJ67jZ2JUcbCFVCYnT36nyq9QzgH9PMr9kM=";
  };

  vendorHash = "sha256-vyYSir5u6d5nv+2ScrHpasQGER4VFSoLb1FDUDIrtDM=";

  patches = [
    # work around https://github.com/CycloneDX/sbom-utility/issues/121, which otherwise
    # breaks shell completions
    ./name.patch
    # Output logs to stderr rather than stdout.
    # Patch of https://github.com/CycloneDX/sbom-utility/pull/122, adapted to apply
    # against v0.17.0
    ./stderr.patch
  ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  preCheck = ''
    cd test
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd sbom-utility \
        --$shell <($out/bin/sbom-utility -q completion $shell)
    done
  '';

  meta = {
    description = "Utility that provides an API platform for validating, querying and managing BOM data";
    homepage = "https://github.com/CycloneDX/sbom-utility";
    changelog = "https://github.com/CycloneDX/sbom-utility/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thillux ];
    mainProgram = "sbom-utility";
  };
}
