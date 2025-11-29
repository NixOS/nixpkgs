{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation rec {
  pname = "popt";
  version = "1.19";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-${version}.tar.gz";
    sha256 = "sha256-wlpIOPyOTByKrLi9Yg7bMISj1jv4mH/a08onWMYyQPk=";
  };

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  patches =
    lib.optionals stdenv.hostPlatform.isCygwin [
      ./1.16-cygwin.patch
      ./1.16-vpath.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      # Do not require <sys/ioctl.h>
      (fetchpatch2 {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/get-w32-console-maxcols.mingw32.patch?h=mingw-w64-popt&id=63f2cdb0de116362c49681cef20f7a8b4355e85a";
        sha256 = "zv43l1RBqNzT/JG+jQaMVFaFv+ZYPuIiAtKUDzJJBbc=";
        stripLen = 1;
        extraPrefix = "src/";
      })

      # Do not try to detect setuid, it is not a thing.
      (fetchpatch2 {
        url = "https://github.com/rpm-software-management/popt/commit/905544c5d9767894edaf71a1e3ce5126944c5695.patch";
        sha256 = "3PmcxeiEZ/Hof0zoVFSytEXvQ8gE8Sp5UdagExPVICU=";
        stripLen = 1;
        extraPrefix = "src/";
        revert = true;
      })
    ];

  doCheck = false; # fails

  meta = with lib; {
    homepage = "https://github.com/rpm-software-management/popt";
    description = "Command line option parsing library";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.unix;
    identifiers.purlParts = {
      type = "github";
      spec = "rpm-software-management/popt@popt-${version}-release";
    };
  };
}
