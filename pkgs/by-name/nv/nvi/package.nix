{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  db,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "nvi";
  version = "1.81.6";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/n/nvi/nvi_${version}.orig.tar.gz";
    hash = "sha256-i8NIiJFZo0zyaPgHILJvRZ29cjtWFhB9NnOdAH5Ml40=";
  };

  patches =
    # Apply patches from debian package
    (map fetchurl (import ./debian-patches.nix))
    ++
      # Also select patches from macports
      # They don't interfere with Linux build
      # https://github.com/macports/macports-ports/tree/master/editors/nvi/files
      (map fetchpatch (import ./macports-patches.nix));

  buildInputs = [
    ncurses
    db
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preConfigure = ''
    cd build.unix
  '';

  configureScript = "../dist/configure";

  configureFlags = [
    "vi_cv_path_preserve=/tmp"
    "--enable-widechar"
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  meta = {
    description = "Berkeley Vi Editor";
    longDescription = ''
      nvi ("new vi") is a re-implementation of the
      classic Berkeley text editor vi, written by
      Keith Bostic at UC Berkeley for 4BSD. Created
      to replace Unix-derived code in BSD, it provides
      a clean, unencumbered version of the original
      editor and is the default vi on all major BSD
      systems as well as MINIX.
    '';
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "vi";
    maintainers = with lib.maintainers; [
      suominen
      aleksana
    ];
  };
}
