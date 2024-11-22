{
  lib,
  stdenv,
  autoreconfHook,
  buildPackages,
  fetchurl,
  flex,
  readline,
  ed,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "bc";
  version = "1.07.1";
  src = fetchurl {
    url = "mirror://gnu/bc/bc-${version}.tar.gz";
    sha256 = "62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a";
  };

  configureFlags = [ "--with-readline" ];

  # As of 1.07 cross-compilation is quite complicated as the build system wants
  # to build a code generator, bc/fbc, on the build machine.
  patches = [ ./cross-bc.patch ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    # Tools
    autoreconfHook
    ed
    flex
    texinfo
    # Libraries for build
    buildPackages.readline
    buildPackages.ncurses
  ];
  buildInputs = [
    readline
    flex
  ];

  doCheck = true; # not cross

  # Hack to make sure we never to the relaxation `$PATH` and hooks support for
  # compatibility. This will be replaced with something clearer in a future
  # masss-rebuild.
  strictDeps = true;

  meta = with lib; {
    description = "GNU software calculator";
    homepage = "https://www.gnu.org/software/bc/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    mainProgram = "bc";
  };
}
