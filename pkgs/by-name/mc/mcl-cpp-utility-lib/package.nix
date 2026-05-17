{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  fmt,
  catch2_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mcl";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "azahar-emu";
    repo = "mcl";
    tag = finalAttrs.version;
    hash = "sha256-7lHOjlUvCQsct/pijn0M0OOG5LpExmXwB6kH+ostA2I=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    fmt
  ];

  checkInputs = [
    catch2_3
  ];

  doCheck = true;
  checkPhase = ''
    tests/mcl-tests
  '';

  meta = {
    description = "Collection of C++20 utilities which is common to a number of merry's projects";
    homepage = "https://github.com/azahar-emu/mcl";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
