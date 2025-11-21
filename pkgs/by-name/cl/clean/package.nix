{
  binutils,
  fetchurl,
  gcc,
  lib,
  runCommand,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clean";
  version = "3.1";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      (fetchurl {
        url = "https://ftp.cs.ru.nl/Clean/Clean31/linux/clean3.1_32_boot.tar.gz";
        sha256 = "Ls0IKf+o7yhRLhtSV61jzmnYukfh5x5fogHaP5ke/Ck=";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://ftp.cs.ru.nl/Clean/Clean31/linux/clean3.1_64_boot.tar.gz";
        sha256 = "Gg5CVZjrwDBtV7Vuw21Xj6Rn+qN1Mf6B3ls6r/16oBc=";
      })
    else
      throw "Architecture not supported";

  hardeningDisable = [ "pic" ];

  patches = [
    ./chroot-build-support-do-not-rebuild-equal-timestamps.patch
    ./declare-functions-explicitly-for-gcc14.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'INSTALL_DIR = $(CURRENTDIR)' "INSTALL_DIR = $out"
    substituteInPlace src/clm/clm.c \
      --replace-fail /usr/bin/as ${binutils}/bin/as \
      --replace-fail /usr/bin/gcc ${gcc}/bin/gcc
  '';

  buildFlags = [ "-C src/" ];

  # do not strip libraries and executables since all symbols since they are
  # required as is for compilation. Especially the labels of unused section need
  # to be kept.
  dontStrip = true;

  passthru.tests.compile-hello-world = runCommand "compile-hello-world" { } ''
    cat >HelloWorld.icl <<EOF
    module HelloWorld
    Start = "Hello, world!"
    EOF
    ${finalAttrs.finalPackage}/bin/clm HelloWorld -o hello-world
    touch $out
  '';

  meta = {
    description = "General purpose, state-of-the-art, pure and lazy functional programming language";
    longDescription = ''
      Clean is a general purpose, state-of-the-art, pure and lazy functional
      programming language designed for making real-world applications. Some
      of its most notable language features are uniqueness typing, dynamic typing,
      and generic functions.
    '';

    homepage = "http://wiki.clean.cs.ru.nl/Clean";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      bmrips
      erin
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "clean";
  };
})
