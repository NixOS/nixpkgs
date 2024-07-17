{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libburn";
  version = "1.5.6";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libburn";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-Xo45X4374FXvlrJ4Q0PahYvuWXO0k3N0ke0mbURYt54=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://dev.lovelyhq.com/libburnia/web/wiki";
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    changelog = "https://dev.lovelyhq.com/libburnia/libburn/src/tag/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      abbradar
      AndersonTorres
    ];
    mainProgram = "cdrskin";
    platforms = lib.platforms.unix;
  };
})
