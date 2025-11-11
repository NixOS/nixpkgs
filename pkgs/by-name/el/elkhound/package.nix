{
  stdenv,
  lib,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "elkhound";
  version = "0-unstable-2020-04-13";

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = "elkhound";
    rev = "a7eb4bb2151c00cc080613a770d37560f62a285c";
    hash = "sha256-Y96OFpBNrD3vrKoEZ4KdJuI1Q4RmYANsu7H3ZzfaA6g=";
  };

  postPatch = ''
    patchShebangs scripts

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    bison
    cmake
    flex
    perl
  ];

  cmakeFlags = [ "-Wno-dev" ]; # it vomits warnings that only upstream cares about

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin ast/astgen elkhound/elkhound
    for d in ast elkhound smbase; do
      install -Dm444 -t $out/lib $d/*.a
      install -Dm444 -t $out/include/$d $src/src/$d/*.h
    done
    install -Dm444 -t $out/share/doc/elkhound $src/src/elkhound/*.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Parser generator which emits GLR parsers, either in OCaml or C++";
    homepage = "https://scottmcpeak.com/elkhound/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "elkhound";
  };
}
