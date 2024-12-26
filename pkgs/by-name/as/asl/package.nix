{
  lib,
  stdenv,
  fetchzip,
  texliveMedium,
  buildDocs ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asl";
  version = "142-bld232";

  src =
    let
      inherit (finalAttrs) pname version;
    in
    fetchzip {
      name = "${pname}-${version}";
      url = "http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current-${version}.tar.bz2";
      hash = "sha256-Q50GzXBxFMhbt5s9OgHPNH4bdqz2hhEmTnMmKowVn2E=";
    };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = lib.optionals buildDocs [ texliveMedium ];

  postPatch =
    lib.optionalString (!buildDocs) ''
      substituteInPlace Makefile --replace "all: binaries docs" "all: binaries"
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      substituteInPlace sysdefs.h --replace "x86_64" "aarch64"
    '';

  dontConfigure = true;

  preBuild = ''
    bindir="${placeholder "out"}/bin" \
    docdir="${placeholder "doc"}/share/doc/asl" \
    incdir="${placeholder "out"}/include/asl" \
    libdir="${placeholder "out"}/lib/asl" \
    mandir="${placeholder "man"}/share/man" \
    substituteAll ${./Makefile-nixos.def} Makefile.def
    mkdir -p .objdir
  '';

  meta = with lib; {
    homepage = "http://john.ccac.rwth-aachen.de:8000/as/index.html";
    description = "Portable macro cross assembler";
    longDescription = ''
      AS is a portable macro cross assembler for a variety of microprocessors
      and -controllers. Though it is mainly targeted at embedded processors and
      single-board computers, you also find CPU families in the target list that
      are used in workstations and PCs.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: cross-compilation support
# TODO: customize TeX input
# TODO: report upstream about `mkdir -p .objdir/`
# TODO: suggest upstream about building docs as an option
