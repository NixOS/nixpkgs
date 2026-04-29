{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "newt";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = finalAttrs.version;
    hash = "sha256-5+B1sderUwy6hJPKFRK8fV0bX2+rgHh3WmAjgQqVsR4=";
  };

  vendorHash = "sha256-+zMSzNbqmWm/DXL2xMUd5uPP5tSIybsRokwJ2zd0pf0=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.newtVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    # Networking failures in tests, even with __darwinAllowLocalNetworking on
    # and sandbox disabled.
    # Unclear as of 2026-04-24 whether the program works if tests are disabled.
    broken = stdenv.hostPlatform.isDarwin;
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/newt";
    changelog = "https://github.com/fosrl/newt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      jackr
      water-sucks
    ];
    mainProgram = "newt";
  };
})
