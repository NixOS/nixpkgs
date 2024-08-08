{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  librnd,
  pkg-config,

  ## Options

  # If non-zero, use this commit to build unstable.
  UnstableRevision ? 0,
  UnstableHash ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "camv-rnd";
  release_version = "1.1.4";

  version =
    if UnstableRevision == 0 then
      finalAttrs.release_version
    else
      "${finalAttrs.release_version}-unstable-r${builtins.toString UnstableRevision}";

  src =
    if UnstableRevision == 0 then
      fetchurl {
        url = "http://repo.hu/projects/camv-rnd/releases/camv-rnd-${finalAttrs.version}.tar.gz";
        hash = "sha256-5rkeM+bKXLpuWxygxN3Z+mk6EReOAkdhdC72DTWlNoE=";
      }
    else
      fetchsvn {
        url = "svn://us.repo.hu/camv-rnd/trunk";
        rev = UnstableRevision;
        hash = UnstableHash;
      };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ librnd ];

  configurePhase = ''
    export LIBRND_PREFIX=${librnd}
    # Two stage configuring: first ./configure to establish librnd location
    # for the packages.sh script to pick up.
    ./configure

    # Generate default configure options using the packages script.
    export PACKAGING_DIR="doc/developer/packaging"
    ( cd "$PACKAGING_DIR" ; ./packages.sh )

    # Now configure for real with the generates configure args and our prefix
    ./configure $(cat "$PACKAGING_DIR/auto/Configure.args") --prefix=$out
  '';

  meta = with lib; {
    description = "A small, flexible viewer for PCB-related CAM file formats";
    homepage = "http://repo.hu/projects/camv-rnd/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ hzeller ];
  };
})
