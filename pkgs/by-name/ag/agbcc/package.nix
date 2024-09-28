{
  lib,
  stdenv,
  pkgsCross,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "agbcc";
  version = "0-unstable-2023-09-03";

  src = fetchFromGitHub {
    owner = "pret";
    repo = "agbcc";
    rev = "bfa92a1c98ce039a7df833beefa612fea65d3874";
    hash = "sha256-yQ4k2gkc8TwPBxHnXvpD0hqv19QP2CAnQMiFZv9Sje0=";
  };

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
    "-Wno-error=format-security"
    "-Wno-error=incompatible-pointer-types"
  ];

  nativeBuildInputs = [ pkgsCross.arm-embedded.buildPackages.binutils ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace libc/Makefile --replace-fail "/bin/bash" "${stdenv.shell}"
    substituteInPlace gcc_arm/configure --replace-fail "main(){return(0);}" "int main(){return(0);}"

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    make -e -C gcc old
    mv gcc/old_agbcc .

    make -e -C gcc
    mv gcc/agbcc .

    cd gcc_arm
    ./configure --target=arm-elf --host=i386-linux-gnu
    make cc1 && cd ..
    mv gcc_arm/cc1 agbcc_arm

    make -C libgcc
    mv libgcc/libgcc.a .

    make -C libc
    mv libc/libc.a .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp old_agbcc $out/bin
    cp agbcc_arm $out/bin
    cp agbcc $out/bin

    mkdir -p $out/include
    cp -r libc/include/* $out/include
    cp ginclude/* $out/include

    mkdir -p $out/lib
    cp libgcc.a $out/lib
    cp libc.a $out/lib

    runHook postInstall
  '';

  meta = {
    description = "GCC reworked to match games compiled for the Game Boy Advance";
    homepage = "https://github.com/pret/agbcc";
    license = lib.licenses.gpl2;
    mainProgram = "agbcc";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      FrothyMarrow
      NotAShelf
    ];
  };
}
