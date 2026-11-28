{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "summon";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bP5AaxyAJogPGefWZdDCkl3aYPVJcPAuaop4XYKcCfM=";
  };

  vendorHash = "sha256-eMW9HHbMR3Q3o/5Y1FKKstnEdtuPrR3cQeBUWJvsBEk=";

  subPackages = [ "cmd" ];

  postPatch = ''
    # Use the declared SDK version instead of forcing latest
    substituteInPlace go.mod \
      --replace-fail \
      'replace github.com/cyberark/conjur-api-go => github.com/cyberark/conjur-api-go latest' \
      ""
  '';

  ldflags = [
    "-X github.com/cyberark/summon/pkg/version.Version=${finalAttrs.version}"
    "-X github.com/cyberark/summon/pkg/version.Tag=nix"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quentini ];
  };
})
