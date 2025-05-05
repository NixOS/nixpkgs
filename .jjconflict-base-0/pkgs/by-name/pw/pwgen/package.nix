{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pwgen";
  version = "2.08";

  src = fetchFromGitHub {
    owner = "tytso";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j6c6m9fcy24jn8mk989x49yk765xb26lpr8yhpiaqk206wlss2z";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    homepage = "https://github.com/tytso/pwgen";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pwgen";
    platforms = platforms.all;
  };
}
