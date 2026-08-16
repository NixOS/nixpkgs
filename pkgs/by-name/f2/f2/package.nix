{
  lib,
  fetchFromGitHub,
  buildGo125Module,
  exiftool,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "f2";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kjq3QTK8FE/UDjy1OAHkzHKuK2EBNHtfDQnFAlyWbYw=";
  };

  vendorHash = "sha256-tkDcC/2EdeNC60vbbRJ3zlsXvOYYkjr0QYO/aeEtQS0=";

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
