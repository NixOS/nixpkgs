{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "guac";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "guacsec";
    repo = "guac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-THrTOqT8xs4EtWL+k7WfiR2SrF5UM4RlhOFd01mJKxs=";
  };

  vendorHash = "sha256-WnP3aKPq2ki1PGYoDT1zvjWdF0h8EeKLF2cG3EpZr2I=";

  subPackages = [
    "cmd/guaccollect"
    "cmd/guaccsub"
    "cmd/guacgql"
    "cmd/guacingest"
    "cmd/guacone"
    "cmd/guacrest"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/guacsec/guac/pkg/version.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Aggregator for software security metadata";
    longDescription = ''
      Graph for Understanding Artifact Composition (GUAC) aggregates software
      security metadata into a high fidelity graph database—normalizing entity
      identities and mapping standard relationships between them.
      Querying this graph can drive higher-level organizational outcomes such
      as audit, policy, risk management, and even developer assistance.
    '';
    homepage = "https://guac.sh/";
    changelog = "https://github.com/guacsec/guac/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "guacone";
  };
})
