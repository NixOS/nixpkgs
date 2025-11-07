{
  lib,
  cmake,
  fetchFromGitHub,
  libGL,
  libiconv,
  libX11,
  openal,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "cen64";
  version = "0.3-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "e0641c8452a3ae8edcd2bf4e46794bb4eaafc076";
    sha256 = "sha256-PpaD3hgksPD729LyFm7+ID8i+x3yZ0f+S11eSQyoB64=";
  };

  # fix build with gcc14:
  # https://github.com/n64dev/cen64/pull/191/commits/f13bdf94c00a9da3b152ed9fe20001e240215b96
  patches = [ ./cast-mi_regs-callbacks.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGL
    libiconv
    openal
    libX11
  ];

  installPhase = ''
    runHook preInstall
    install -D {,$out/bin/}${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Cycle-Accurate Nintendo 64 Emulator";
    license = licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = [ maintainers._414owen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cen64";
  };
}
