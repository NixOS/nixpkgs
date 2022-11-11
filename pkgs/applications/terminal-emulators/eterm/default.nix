{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, imlib2
, libX11
, libXaw
, libXext
, libast
, pkg-config
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "eterm";
  version = "0.9.6+date=2020-03-03";

  src = fetchFromGitHub {
    owner = "mej";
    repo = pname;
    rev = "e8fb85b56da21113aaf0f5f7987ae647c4413b6c";
    sha256 = "sha256-pfXYrd6BamBTcnarvXj+C6D1WyGtj87GrW+Dl6AeiDE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    imlib2
    libX11
    libXaw
    libXext
    libast
  ];

  passthru.tests.test = nixosTests.terminal-emulators.eterm;

  meta = with lib; {
    homepage = "https://github.com/mej/Eterm"; # http://www.eterm.org is gone
    description = "Terminal emulator";
    license = licenses.bsd2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    knownVulnerabilities = [
      ''Usage of ANSI escape sequences causes unexpected newline-termination,
        leading to unexpected command execution. More info at:
        - https://www.cve.org/CVERecord?id=CVE-2021-33477
        - https://www.openwall.com/lists/oss-security/2021/05/17/1''
    ];
  };
}
