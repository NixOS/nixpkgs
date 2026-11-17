{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ldap-manager";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "netresearch";
    repo = "ldap-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MqR4Dj/obMpUKGDMDwEi8kQMMFQXVBPjDBby5t7RfAk=";
  };

  vendorHash = "sha256-ZM2MjG3roOl4PFiBuo9F8cTTVWt1ZHuNmaZFvpH804c=";

  excludedPackages = [
    "internal/e2e"
    "internal/integration"
  ];

  preBuild = ''
    go tool templ generate
  '';

  ldflags = [
    "-s"
    "-X github.com/netresearch/ldap-manager/internal/version.Version=${finalAttrs.version}"
    "-X github.com/netresearch/ldap-manager/internal/version.BuildTimestamp=1970-01-01T00:00:00"
  ];

  postInstall = ''
    mv $out/bin/ldap-manager $out/bin/ldap-passwd
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web frontend that allows users to administrate their LDAP users";
    homepage = "https://github.com/netresearch/ldap-manager";
    changelog = "https://github.com/netresearch/ldap-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "ldap-passwd";
  };
})
