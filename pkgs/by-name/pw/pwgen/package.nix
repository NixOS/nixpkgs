{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pwgen";
  version = "2.08";

  src = fetchFromGitHub {
    owner = "tytso";
    repo = "pwgen";
    rev = "v${finalAttrs.version}";
    sha256 = "1j6c6m9fcy24jn8mk989x49yk765xb26lpr8yhpiaqk206wlss2z";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    homepage = "https://github.com/tytso/pwgen";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pwgen";
    platforms = lib.platforms.all;
  };
})
