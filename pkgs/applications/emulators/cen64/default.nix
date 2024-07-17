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
  version = "unstable-2022-10-02";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "ee6db7d803a77b474e73992fdc25d76b9723d806";
    sha256 = "sha256-/CraSu/leNA0dl8NVgFjvKdOWrC9/namAz5NSxtPr+I=";
  };

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
    description = "A Cycle-Accurate Nintendo 64 Emulator";
    license = licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = [ maintainers._414owen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cen64";
  };
}
