{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  python3,
}:

let
  zycore = callPackage ./zycore.nix {
    inherit stdenv fetchFromGitHub cmake;
  };
in
stdenv.mkDerivation rec {
  pname = "zydis";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    hash = "sha256-akusu0T7q5RX4KGtjRqqOFpW5i9Bd1L4RVZt8Rg3PJY=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ zycore ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  doCheck = true;
  nativeCheckInputs = [ python3 ];
  passthru = { inherit zycore; };

  meta = with lib; {
    homepage = "https://zydis.re/";
    changelog = "https://github.com/zyantific/zydis/releases/tag/v${version}";
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = licenses.mit;
    maintainers = with maintainers; [
      jbcrail
      AndersonTorres
      athre0z
    ];
    platforms = platforms.all;
  };
}
