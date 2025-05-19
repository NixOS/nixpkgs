{
  lib,
  fetchFromGitHub,
  buildGoModule,
  exiftool,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "f2";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hl4giLTQtqJiPseiTzWPtksEYlyQpE1UOC7JMUF9v4Y=";
  };

  vendorHash = "sha256-xeylGT32bGMJjGdpQQH8DBpqxtvMxpqSEsLPbeoUzl4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ayoisaiah/f2/v2/app.VersionString=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ exiftool ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
      zendo
    ];
    mainProgram = "f2";
  };
})
