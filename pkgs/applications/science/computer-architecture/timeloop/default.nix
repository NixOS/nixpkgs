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
  version = "unstable-2022-11-29";

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = "timeloop";
    rev = "905ba953432c812772de935d57fd0a674a89d3c1";
    hash = "sha256-EXiWXf8hdX4vFRNk9wbFSOsix/zVkwrafGUtFrsoAN0=";
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
  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-fno-lto";

  postPatch = ''
    # use nix ar/ranlib
    substituteInPlace ./SConstruct \
      --replace "env.Replace(AR = \"gcc-ar\")" "" \
      --replace "env.Replace(RANLIB = \"gcc-ranlib\")" ""
    '' + lib.optionalString stdenv.isDarwin ''
    # prevent clang from dying on errors that gcc is fine with
    substituteInPlace ./src/SConscript --replace "-Werror" "-Wno-inconsistent-missing-override"

    # disable LTO on macos
    substituteInPlace ./src/SConscript --replace ", '-flto'" ""

    # static builds on mac fail as no static libcrt is provided by apple
    # see https://stackoverflow.com/questions/3801011/ld-library-not-found-for-lcrt0-o-on-osx-10-6-with-gcc-clang-static-flag
    substituteInPlace ./src/SConscript \
      --replace "'-static-libgcc', " "" \
      --replace "'-static-libstdc++', " "" \
      --replace "'-Wl,--whole-archive', '-static', " "" \
      --replace ", '-Wl,--no-whole-archive'" ""

    #remove hardcoding of gcc
    sed -i '40i env.Replace(CC = "${stdenv.cc.targetPrefix}cc")' ./SConstruct
    sed -i '40i env.Replace(CXX = "${stdenv.cc.targetPrefix}c++")' ./SConstruct

    #gpm doesn't exist on darwin
    substituteInPlace ./src/SConscript --replace ", 'gpm'" ""
   '';

  sconsFlags =
    # will fail on clang/darwin on link without --static due to undefined extern
    # however, will fail with static on linux as nixpkgs deps aren't static
    lib.optional stdenv.isDarwin "--static"
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
