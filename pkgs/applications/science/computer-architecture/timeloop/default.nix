{ lib
, stdenv
, fetchFromGitHub
, scons
, libconfig
, boost
, libyaml
, yaml-cpp
, ncurses
, gpm
, enableAccelergy ? true
, enableISL ? false
, accelergy
}:

stdenv.mkDerivation rec {
  pname = "timeloop";
  version = "unstable-2023-04-21";

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = "timeloop";
    rev = "e5a31c75f1f1f543d6109d72e84c4b4978509f3a";
    hash = "sha256-zO+5qdstr8BolMk0XcHQE2rjpb8VkgKHNBif7G8u81U=";
  };

  nativeBuildInputs = [ scons ];

  buildInputs = [
    libconfig
    boost
    libyaml
    yaml-cpp
    ncurses
    accelergy
   ] ++ lib.optionals stdenv.isLinux [ gpm ];

  preConfigure = ''
    cp -r ./pat-public/src/pat ./src/pat
  '';

  enableParallelBuilding = true;

  #link-time optimization fails on darwin
  #see https://github.com/NixOS/nixpkgs/issues/19098
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-fno-lto";

  postPatch = lib.optionalString stdenv.isDarwin ''
    #remove hardcoding of gcc
    sed -i '40i env.Replace(CC = "${stdenv.cc.targetPrefix}cc")' ./SConstruct
    sed -i '40i env.Replace(CXX = "${stdenv.cc.targetPrefix}c++")' ./SConstruct
   '';

  sconsFlags =
    lib.optional stdenv.isDarwin "--clang"
    ++ lib.optional enableAccelergy "--accelergy"
    ++ lib.optional enableISL "--with-isl";


  installPhase = ''
    cp -r ./bin ./lib $out
    mkdir -p $out/share
    cp -r ./doc $out/share
    mkdir -p $out/data
    cp -r ./problem-shapes ./configs $out/data
   '';

  meta = with lib; {
    description = "Chip modeling/mapping benchmarking framework";
    homepage = "https://timeloop.csail.mit.edu";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gdinh ];
  };
}
