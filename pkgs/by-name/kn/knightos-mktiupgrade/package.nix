{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libxslt,
  asciidoc,
}:

stdenv.mkDerivation rec {
  pname = "mktiupgrade";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mktiupgrade";
    rev = version;
    sha256 = "15y3rxvv7ipgc80wrvrpksxzdyqr21ywysc9hg6s7d3w8lqdq8dm";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    cmake
    libxslt.bin
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "https://knightos.org/";
    description = "Makes TI calculator upgrade files from ROM dumps";
    mainProgram = "mktiupgrade";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
