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
  version = "26.11";
  tag = "v0.2611.0";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "meowlnir";
    inherit tag;
    hash = "sha256-HOh2+ZXR8289XZdydQtD4UjOHvJ5RsEsrbThu7tfwg0=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-imBB+KPifHq8KEmJ6zfMsJKadm/XV47scKS97XYphBc=";

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
