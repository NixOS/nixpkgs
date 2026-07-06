{
  lib,
  buildGoModule,
  fetchFromGitHub,
  templ,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ldap-manager";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "netresearch";
    repo = "ldap-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wq/VZ+F/m13YQjJfCoN+UgaeAazWup2JINJ3I9KM3d0=";
  };

  vendorHash = "sha256-sE8XGlQg6FLDfgYdioa5i5Gv8LyQo16p0oIaiyMOzZ4=";

  nativeBuildInputs = [
    templ
  ];

  excludedPackages = [
    "internal/e2e"
    "internal/integration"
  ];

  preBuild = ''
    templ generate
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
