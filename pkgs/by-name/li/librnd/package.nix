{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  gd,
  glib,
  gtk2,
  gtk4,
  gnome2,
  libGLU,
  libepoxy,
  pkg-config,
  wget,

  ## Options
  withGtk2 ? true,
  withGtk4 ? false,

  # If non-zero, use this commit to build unstable.
  UnstableRevision ? 0,
  UnstableHash ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librnd";
  release_version = "4.3.0";

  version =
    if UnstableRevision == 0 then
      finalAttrs.release_version
    else
      "${finalAttrs.release_version}-unstable-r${builtins.toString UnstableRevision}";

  src =
    if UnstableRevision == 0 then
      fetchurl {
        url = "http://repo.hu/projects/librnd/releases/librnd-${finalAttrs.version}.tar.gz";
        hash = "sha256-jeF3WEOyKEaGzscAnfIiLDm5NlGQKhWgKyT0wvwVfaE=";
      }
    else
      fetchsvn {
        url = "svn://us.repo.hu/librnd/trunk";
        rev = UnstableRevision;
        hash = UnstableHash;
      };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      wget
      gd
      glib
      libGLU
    ]
    ++ lib.optionals withGtk2 [
      gtk2
      gnome2.gtkglext
    ]
    ++ lib.optionals withGtk4 [
      gtk4
      libepoxy
    ];

  configurePhase = ''
    # Generate default configure options using the packages script.
    export PACKAGING_DIR="doc/developer/packaging"
    ( cd "$PACKAGING_DIR" ; ./packages.sh )

    ./configure $(cat "$PACKAGING_DIR/auto/Configure.args") --prefix=$out
  '';

  doCheck = true;
  checkPhase = "make test";

  meta = with lib; {
    description = "A modular framework library for 2D CAD applications";
    homepage = "http://repo.hu/projects/librnd/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ hzeller ];
  };
})
