{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitlink-cli";
  version = "0.1.18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ccfos";
    repo = "gitlink-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SPOrTZG2/9Q501CovTetU+CrcytHUcc+xpqTyMBkXsE=";
  };

  vendorHash = "sha256-lmQ2QsfxZxgp67vSxHGWNMOgdXPLfKVIDqfVAlIY2S0=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/gitlink-org/gitlink-cli/cmd.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for the GitLink (确实开源) code hosting platform";
    longDescription = ''
      The official GitLink CLI tool — built for humans and AI Agents. Covers
      repository management, issue tracking, pull requests, CI/CD, and
      AI-powered workflows.
    '';
    homepage = "https://github.com/ccfos/gitlink-cli";
    changelog = "https://github.com/ccfos/gitlink-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mulan-psl2;
    mainProgram = "gitlink-cli";
    maintainers = with lib.maintainers; [ silicalet ];
  };
})
