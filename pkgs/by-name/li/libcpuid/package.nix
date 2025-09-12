{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    hash = "sha256-m/4PJGknuoiWR40aIHtkaHuMEROjsYQ9ZgmJtHdzeSU=";
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
      artuuge
    ];
    platforms = platforms.x86;
  };
}
