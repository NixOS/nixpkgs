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
  version = "1.08.1";
  src = fetchurl {
    url = "mirror://gnu/bc/bc-${version}.tar.xz";
    hash = "sha256-UVQwEVszNMY2MXUDRgoJUN/3mUCqMlnOLBqmfCiB0CM=";
  };

  configureFlags = [ "--with-readline" ];

  # As of 1.07 cross-compilation is quite complicated as the build system wants
  # to build a code generator, bc/fbc, on the build machine.
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
