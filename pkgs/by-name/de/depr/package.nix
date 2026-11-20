{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "depr";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "EdgeLordKirito";
    repo = "depr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6cnTnnW1XSQMEGf6cfnbgSLAme2j3wLH09z6aTYbh54=";
  };

  vendorHash = "sha256-GZJa45RH/0KcfJZKoM4yBiKhRa8+B3kxXyhrc7u7qR0=";

  ldflags = [
    "-s"
    "-X codeberg.org/EdgeLordKirito/depr/cmd.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Toggle a suffix (default .old) on files and directories";
    homepage = "https://codeberg.org/EdgeLordKirito/depr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ EdgeLordKirito ];
    mainProgram = "depr";
  };
})
