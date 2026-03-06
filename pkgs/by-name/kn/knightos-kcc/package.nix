{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcc";

  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kcc";
    rev = finalAttrs.version;
    sha256 = "13sbpv8ynq8sjackv93jqxymk0bsy76c5fc0v29wz97v53q3izjp";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
  ];

  buildInputs = [ boost ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/KnightOS/kcc";
    description = "KnightOS C compiler";
    mainProgram = "kcc";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
