{
  aws-lc,
  sqlite,
  pkg-config,
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eilmeldung";
  version = "1.10.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christo-auer";
    repo = "eilmeldung";
    tag = finalAttrs.version;
    hash = "sha256-JaRw4yFkePxqxD9kvW92dza0k4AVMTgXjORHHZufGyI=";
  };

  cargoHash = "sha256-0DRR92K40q0xVOQYOIrJ020hjmOJ5hkNY3Del62eInc=";

  buildInputs = [
    aws-lc
    sqlite
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Feature-rich TUI RSS reader based on the news-flash library";
    homepage = "https://github.com/christo-auer/eilmeldung";
    changelog = "https://github.com/christo-auer/eilmeldung/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      christo-auer
      rachitvrma
    ];
    mainProgram = "eilmeldung";
  };
})
