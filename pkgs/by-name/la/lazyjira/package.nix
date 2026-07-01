{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lazyjira";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "textfuel";
    repo = "lazyjira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6Ip7GjrqosUuj8uURQrqXetIbvhhsymdEQhvlBMkww=";
  };

  vendorHash = "sha256-+Vepf1VohkjtL7JvmuZv8qZ5FiLarII+bx4jK6C2bBU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lazygit but for Jira";
    longDescription = ''
      Jira's web UI is painfully slow.  Changing a ticket status takes
      multiple clicks, pages take seconds to load, and you spend more
      time fighting the interface than actually working.  lazyjira
      gives you a fast, keyboard-driven terminal UI so you can browse
      issues, update statuses, read descriptions and more with minimum
      latency.
    '';
    homepage = "https://github.com/textfuel/lazyjira";
    changelog = "https://github.com/textfuel/lazyjira/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lazyjira";
  };
})
