{ lib, stdenv, fetchurl, makeWrapper, cmake, pkgconfig
, wlc, dbus_libs, wayland, libxkbcommon, pixman, libinput, udev, zlib, libpng, libdrm, libX11
}:

stdenv.mkDerivation rec {
  name = "orbment-${version}";
  version = "git-2015-09-30";
  repo = "https://github.com/Cloudef/orbment";
  rev = "229a870dbbb9dbc66c137cf2747eab11acdf1a95";

  chck_repo = "https://github.com/Cloudef/chck";
  chck_rev = "6191a69572952291c137294317874c06c9c0d6a9";
  inihck_repo = "https://github.com/Cloudef/inihck";
  inihck_rev = "462cbd5fd67226714ac2bdfe4ceaec8e251b2d9c";

  srcs = [
   (fetchurl {
     url = "${repo}/archive/${rev}.tar.gz";
     sha256 = "7aaa0262d078adaf47abdf500b9ea581f6bec164c195a44a3c165a865414ca2c";
   })
   (fetchurl {
     url = "${chck_repo}/archive/${chck_rev}.tar.gz";
     sha256 = "26b4af1390bf67c674732cad69fc94fb027a3d269241d0bd862f42fb80bd5160";
   })
   (fetchurl {
     url = "${inihck_repo}/archive/${inihck_rev}.tar.gz";
     sha256 = "d21f2ac25eafed285614f5f0ef7a1014d629ba382f4e64bc89fe2c3e98c2777f";
   })
  ];

  sourceRoot = "orbment-${rev}";
  postUnpack = ''
    rm -rf orbment-${rev}/lib/chck orbment-${rev}/lib/inihck
    ln -s ../../chck-${chck_rev} orbment-${rev}/lib/chck
    ln -s ../../inihck-${inihck_rev} orbment-${rev}/lib/inihck
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ makeWrapper wlc dbus_libs wayland libxkbcommon pixman libinput udev zlib libpng libX11 libdrm ];
  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  LD_LIBRARY_PATH = lib.makeLibraryPath [ libX11 libdrm dbus_libs ];
  preFixup = ''
    wrapProgram $out/bin/orbment \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  meta = {
    description = "Modular Wayland compositor";
    homepage    = repo;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
