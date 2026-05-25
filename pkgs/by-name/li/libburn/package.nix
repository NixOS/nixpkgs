{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
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

  patches = [
    # Fix the build against C23 compilers (like gcc-15):
    (fetchpatch {
      name = "c23.patch";
      url = "https://dev.lovelyhq.com/libburnia/libburn/commit/d537f9dd35282df834a311ead5f113af67d223b3.patch";
      hash = "sha256-aouU/6AchLhzMzvkVvUnFHWfebYTrkEJ6P3fF5pvE9M=";
    })
  ];

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
