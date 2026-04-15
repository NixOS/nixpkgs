{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpthread-stubs,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "peaclock";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "octobanana";
    repo = "peaclock";
    rev = version;
    sha256 = "1582vgslhpgbvcd7ipgf1d1razrvgpq1f93q069yr2bbk6xn8i16";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpthread-stubs
    icu
  ];

  meta = {
    description = "Clock, timer, and stopwatch for the terminal";
    homepage = "https://octobanana.com/software/peaclock";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ djanatyn ];
    mainProgram = "peaclock";
  };
}
