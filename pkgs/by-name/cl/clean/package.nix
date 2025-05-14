{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "clean";
  version = "3.0";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      (fetchurl {
        url = "https://ftp.cs.ru.nl/Clean/Clean30/linux/clean3.0_32_boot.tar.gz";
        sha256 = "0cjxv3vqrg6pz3aicwfdz1zyhk0q650464j3qyl0wzaikh750010";
      })
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://ftp.cs.ru.nl/Clean/Clean30/linux/clean3.0_64_boot.tar.gz";
        sha256 = "06k283y9adbi28f78k3m5ssg6py73qqkz3sm8dgxc89drv4krl2i";
      })
    else
      throw "Architecture not supported";

  hardeningDisable = [
    "format"
    "pic"
  ];

  # clm uses timestamps of dcl, icl, abc and o files to decide what must be rebuild
  # and for chroot builds all of the library files will have equal timestamps.  This
  # makes clm try to rebuild the library modules (and fail due to absence of write permission
  # on the Nix store) every time any file is compiled.
  patches = [ ./chroot-build-support-do-not-rebuild-equal-timestamps.patch ];

  preBuild = ''
    substituteInPlace Makefile --replace 'INSTALL_DIR = $(CURRENTDIR)' 'INSTALL_DIR = '$out

    substituteInPlace src/tools/clm/clm.c --replace '/usr/bin/gcc' $(type -p gcc)
    substituteInPlace src/tools/clm/clm.c --replace '/usr/bin/as' $(type -p as)

    cd src
  '';

  postBuild = ''
    cd ..
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
    maintainers = [ lib.maintainers.erin ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
