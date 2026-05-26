{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,

  # modules (https://github.com/Kioubit/FlapAlerted#module-documentation)
  withHttpApi ? true,
  withLog ? true,
  withScript ? true,
  withWebhook ? true,
  withCollector ? true,
  withHistory ? true,
  withRoaFilter ? false,
}:

buildGoModule (finalAttrs: {
  pname = "flap-alerted";
  version = "4.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kioubit";
    repo = "FlapAlerted";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D4+FLAMt/cHXCks4GQI33ymbZIHzBajpvKU6QQntofk=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  tags =
    lib.optionals (!withHttpApi) [ "disable_mod_httpAPI" ]
    ++ lib.optionals (!withLog) [ "disable_mod_log" ]
    ++ lib.optionals (!withScript) [ "disable_mod_script" ]
    ++ lib.optionals (!withWebhook) [ "disable_mod_webhook" ]
    ++ lib.optionals (!withCollector) [ "disable_mod_collector" ]
    ++ lib.optionals (!withHistory) [ "disable_mod_history" ]
    ++ lib.optionals withRoaFilter [ "mod_roaFilter" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) flap-alerted; };
  };

  meta = {
    description = "BGP Update based flap detection & statistics";
    homepage = "https://github.com/Kioubit/FlapAlerted";
    changelog = "https://github.com/Kioubit/FlapAlerted/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "FlapAlerted";
  };
})
