{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "cde";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "corr-CDE";
    rev = "v${version}";
    sha256 = "sha256-s375gtqBWx0GGXALXR+fN4bb3tmpvPNu/3bNz+75UWU=";
  };

  # The build is small, so there should be no problem
  # running this locally. There is also a use case for
  # older systems, where modern binaries might not be
  # useful.
  preferLocalBuild = true;

  buildInputs = [ libxcrypt ];

  patchBuild = ''
    sed -i -e '/install/d' $src/Makefile
  '';

  preBuild = ''
    patchShebangs .
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ../readelf-mini/libreadelf-mini.a(dwarf.o):/build/source/readelf-mini/dwarf.c:64:
  #     multiple definition of `do_wide'; ../readelf-mini/libreadelf-mini.a(readelf-mini.o):/build/source/readelf-mini/readelf-mini.c:170: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  installPhase = ''
    install -d $out/bin
    install -t $out/bin cde cde-exec
  '';

  meta = with lib; {
    homepage = "https://github.com/usnistgov/corr-CDE";
    description = "Packaging tool for building portable packages";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
    # error: architecture aarch64 is not supported by bundled strace
    badPlatforms = [ "aarch64-linux" ];
  };
}
