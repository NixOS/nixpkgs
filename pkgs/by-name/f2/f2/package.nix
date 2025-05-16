{
  lib,
  fetchFromGitHub,
  buildGoModule,
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

  # has no tests
  doCheck = false;

  meta = {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "f2";
  };
})
