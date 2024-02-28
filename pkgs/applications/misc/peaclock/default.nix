{ lib, stdenv, fetchFromGitHub, cmake, libpthreadstubs, icu }:

stdenv.mkDerivation rec {
  pname = "peaclock";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "octobanana";
    repo = pname;
    rev = version;
    sha256 = "1582vgslhpgbvcd7ipgf1d1razrvgpq1f93q069yr2bbk6xn8i16";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpthreadstubs icu ];

  meta = with lib; {
    description = "A clock, timer, and stopwatch for the terminal";
    homepage = "https://octobanana.com/software/peaclock";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "peaclock";
  };
}
