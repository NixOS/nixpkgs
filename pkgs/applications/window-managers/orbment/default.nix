{ lib, stdenv, fetchurl, makeWrapper, cmake, pkgconfig
, wlc, dbus_libs, wayland, libxkbcommon, pixman, libinput, udev, zlib, libpng, libdrm, libX11
}:

stdenv.mkDerivation rec {
  name = "orbment-${version}";
  version = "git-2016-01-31";
  repo = "https://github.com/Cloudef/orbment";
  rev = "7f649fb76649f826dd29578a5ec41bb561b116eb";

  chck_repo = "https://github.com/Cloudef/chck";
  chck_rev = "fe5e2606b7242aa5d89af2ea9fd048821128d2bc";
  inihck_repo = "https://github.com/Cloudef/inihck";
  inihck_rev = "462cbd5fd67226714ac2bdfe4ceaec8e251b2d9c";

  srcs = [
   (fetchurl {
     url = "${repo}/archive/${rev}.tar.gz";
     sha256 = "5a426da0d5f4487911cfe9226865ed0cd1a7cdf253eec19d5eadc4b0d14a2ea0";
   })
   (fetchurl {
     url = "${chck_repo}/archive/${chck_rev}.tar.gz";
     sha256 = "ca316b544c48e837c32f08d613be42da10e0a3251e8e4488d1848b91ef92ab9e";
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
