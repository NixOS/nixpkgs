{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  librnd,
  libxml2,
  gd,
  freetype,
  pkg-config,
  imagemagick,

  ## Options

  # If non-zero, use this commit to build unstable.
  UnstableRevision ? 0,
  UnstableHash ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcb-rnd";
  release_version = "3.1.5";

  version =
    if UnstableRevision == 0 then
      finalAttrs.release_version
    else
      "${finalAttrs.release_version}-unstable-r${builtins.toString UnstableRevision}";

  src =
    if UnstableRevision == 0 then
      fetchurl {
        url = "http://repo.hu/projects/pcb-rnd/releases/pcb-rnd-${finalAttrs.version}.tar.gz";
        hash = "sha256-kWY+a1Q+P2heEywoR0tzFLr7A5M6krJxaA09vmPPq7E=";
      }
    else
      fetchsvn {
        url = "svn://us.repo.hu/pcb-rnd/trunk";
        rev = UnstableRevision;
        hash = UnstableHash;
      };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [
    imagemagick # test phases uses that to compare reference images
  ];

  buildInputs = [
    librnd
    libxml2
    gd
    freetype
  ];

  configurePhase = ''
    export LIBRND_PREFIX=${librnd}
    # Two stage configuring: first ./configure to establish librnd location
    # for the packages.sh script to pick up.
    ./configure

    # Generate default configure options using the packages script.
    export PACKAGING_DIR="doc/developer/packaging"
    ( cd "$PACKAGING_DIR" ; ./packages.sh )

    # Now configure for real with the generates configure args and our prefix
    ./configure $(cat "$PACKAGING_DIR/auto/Configure.args") \
      --cflags/libs/sul/freetype2="$(pkg-config --cflags freetype2)/freetype"\
      --ldflags/libs/sul/freetype2="$(pkg-config --libs freetype2)"\
      --prefix=$out
  '';

  doCheck = true;
  checkPhase = "make test";

  meta = with lib; {
    description = "A flexible, modular Printed Circuit Board editor";
    homepage = "http://repo.hu/projects/pcb-rnd/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ hzeller ];
  };
})
