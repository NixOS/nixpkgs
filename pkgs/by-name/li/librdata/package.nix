{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "librdata";
  version = "0-unstable-2023-10-03";

  src = fetchFromGitHub {
    owner = "WizardMac";
    repo = "librdata";
    rev = "33bd276ecb0bbcd8997ccc71a544149b3da0d940";
    hash = "sha256-njTlKK++v7IbaRWJw8hWpE4tXh8MjPRijacqor7Rwes=";
  };

  patches = [ ./gettext-fix.patch ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Read and write R data frames from C";
    homepage = "https://github.com/WizardMac/librdata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
}
