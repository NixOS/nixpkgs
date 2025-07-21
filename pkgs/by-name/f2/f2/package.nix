{
  lib,
  fetchFromGitHub,
  buildGoModule,
  exiftool,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "f2";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Roectcq8jMtw9bFnojJBq4+8dG7V4AGxclfqVSTdl4A=";
  };

  vendorHash = "sha256-i6hgLj1zu8D0mrO0f+SZ4wAkmMKIPtzOKpu9zMAEML0=";

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
