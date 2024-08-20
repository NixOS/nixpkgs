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
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = "timeloop";
    rev = "v${version}";
    hash = "sha256-CGPhrBNzFdERAA/Eym2v0+FvFUe+VkBLnwYEqEMHE9k=";
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

  postPatch = ''
    # Fix gcc-13 build failure due to missing includes:
    sed -e '1i #include <cstdint>' -i \
      include/compound-config/compound-config.hpp

    # use nix ar/ranlib
    substituteInPlace ./SConstruct \
      --replace-fail "env.Replace(AR = \"gcc-ar\")" "pass" \
      --replace-fail "env.Replace(RANLIB = \"gcc-ranlib\")" "pass"
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
