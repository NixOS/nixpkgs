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
  version = "0.19.2";
in
buildGoModule {
  pname = "sbom-utility";
  inherit version;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "sbom-utility";
    tag = "v${version}";
    hash = "sha256-xjANZxjPQmaBZPt+yF2UTJ1QL7QN0wSFxNMZ2oF6p7s=";
  };

  vendorHash = "sha256-vyYSir5u6d5nv+2ScrHpasQGER4VFSoLb1FDUDIrtDM=";

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
