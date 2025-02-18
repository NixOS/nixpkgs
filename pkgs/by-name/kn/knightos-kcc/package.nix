{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "kcc";

  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kcc";
    rev = version;
    sha256 = "13sbpv8ynq8sjackv93jqxymk0bsy76c5fc0v29wz97v53q3izjp";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
  ];

  buildInputs = [ boost ];

  meta = with lib; {
    homepage = "https://knightos.org/";
    description = "KnightOS C compiler";
    mainProgram = "kcc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
