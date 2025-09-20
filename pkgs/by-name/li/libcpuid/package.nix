{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    hash = "sha256-+/TTlGk1ePPTHrSTSZmPHT2h3gKs9ouCF4ElvLWHF/g=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://libcpuid.sourceforge.net/";
    description = "Small C library for x86 CPU detection and feature extraction";
    mainProgram = "cpuid_tool";
    changelog = "https://raw.githubusercontent.com/anrieff/libcpuid/master/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      orivej
    ];
    platforms = platforms.x86;
  };
}
