{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libburn";
  version = "1.5.8";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libburn";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-W/9dUUQGB1V76G9YshNjJcrptAuVVcsXiM5ZQ9Q50Xs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dev.lovelyhq.com/libburnia/web/wiki";
    description = "Library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    changelog = "https://dev.lovelyhq.com/libburnia/libburn/src/tag/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "cdrskin";
    platforms = lib.platforms.unix;
  };
})
