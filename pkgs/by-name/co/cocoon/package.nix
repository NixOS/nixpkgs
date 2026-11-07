{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenvNoCC,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cocoon";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pvbEXY/ps+XB/Peq3+R76D2zd06Y33W1xzrnDiXiqxI=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-2MF2rB+7DSjaF1bmyC2TcNaHFLaBOk6BIBFVDevPnDA=";

  passthru = {
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux { inherit (nixosTests) cocoon; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ATProtocol Personal Data Server written in Go with a SQLite block and blob store";
    changelog = "https://github.com/haileyok/cocoon/releases/v${finalAttrs.version}";
    homepage = "https://github.com/haileyok/cocoon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cocoon";
  };
})
