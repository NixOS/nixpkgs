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
  version = "0-unstable-2023-05-29";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "1c1118462bd9d9b8ceb4c556a647718072477aab";
    sha256 = "sha256-vFk29KESATcEY0eRNbS+mHLD9T1phJiG1fqjOlI19/w=";
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
    description = "Cycle-Accurate Nintendo 64 Emulator";
    license = licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = [ maintainers._414owen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cen64";
  };
}
