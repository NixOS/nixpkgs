{ lib
, stdenv
, fetchurl
, gettext
, help2man
, pkg-config
, texinfo
, makeWrapper
, boehmgc
, readline
, guiSupport ? false, tcl, tcllib, tk
, miSupport ? true, json_c
, nbdSupport ? !stdenv.isDarwin, libnbd
, textStylingSupport ? true
, dejagnu
}:

let
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in stdenv.mkDerivation rec {
  pname = "poke";
  version = "1.3";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-unhjA0obCABLDuj4i9qUFgcH6aeB1VVvVVtQdYPPDxs=";
  };

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    help2man
    pkg-config
    texinfo
  ] ++ lib.optional guiSupport makeWrapper;

  buildInputs = [ boehmgc readline ]
  ++ lib.optionals guiSupport [ tk tcl.tclPackageHook tcllib ]
  ++ lib.optional miSupport json_c
  ++ lib.optional nbdSupport libnbd
  ++ lib.optional textStylingSupport gettext
  ++ lib.optional (!isCross) dejagnu;

  configureFlags = lib.optionals guiSupport [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-tkinclude=${tk.dev}/include"
  ];

  enableParallelBuilding = true;

  doCheck = !isCross;
  checkInputs = lib.optionals (!isCross) [ dejagnu ];

  meta = with lib; {
    description = "Interactive, extensible editor for binary data";
    homepage = "http://www.jemarch.net/poke";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres kira-bruneau ];
    platforms = platforms.unix;
    changelog = "https://git.savannah.gnu.org/cgit/poke.git/plain/ChangeLog?h=releases/poke-${version}";
  };
}

# TODO: Enable guiSupport by default once it's more than just a stub
