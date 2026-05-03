{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "meowlnir";
  version = "26.04";
  tag = "v0.2604.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    inherit tag;
    hash = "sha256-zLPRsEbusci9FoI0Pwb4CsQo5GB4QlXdCH+oGQUdx8E=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-ev0UjRuJpxruemz9DxHxi43SuLQ28a1NOSuM3td1s6Q=";

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/maunium/meowlnir";
    description = "Opinionated Matrix moderation bot";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sumnerevans ];
    mainProgram = "meowlnir";
  };
}
