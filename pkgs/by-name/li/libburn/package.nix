{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libburn";
  version = "1.5.8";

  src = fetchFromGitea {
    domain = "dev.lovelyhq.com";
    owner = "libburnia";
    repo = "libburn";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-W/9dUUQGB1V76G9YshNjJcrptAuVVcsXiM5ZQ9Q50Xs=";
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
    description = "Library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    changelog = "https://dev.lovelyhq.com/libburnia/libburn/src/tag/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "cdrskin";
    platforms = lib.platforms.unix;
  };
})
