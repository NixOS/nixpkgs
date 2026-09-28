{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  hugo,
}:

buildNpmPackage (finalAttrs: {
  pname = "blowfish-tools";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "nunocoracao";
    repo = "blowfish-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bVH+7YhClIpbSgtILgT/qL3ZmQYGRzA1drrb0cAkZmQ=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-KFR97H3uTskKkk7rXdn96/R59FJ2aeNeMo/OW8J4JXw=";

  postFixup = ''
    wrapProgram $out/bin/blowfish-tools \
      --prefix PATH : ${lib.makeBinPath [ hugo ]}
  '';

  meta = {
    description = "CLI to initialize and configure a Blowfish project";
    homepage = "https://blowfish.page";
    changelog = "https://github.com/nunocoracao/blowfish-tools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eripa
      thattemperature
    ];
    mainProgram = "blowfish-tools";
  };
})
