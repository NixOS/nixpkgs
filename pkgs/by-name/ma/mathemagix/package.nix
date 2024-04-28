{
  stdenv,
  lib,
  fetchsvn,
  readline,
  ncurses,
  bison,
  libtool,
  gmp,
  mpfr,
  enable-algebramix ? true,
  enable-automagix ? true,
  enable-basix ? true,
  enable-mmcompileregg ? true,
  enable-mmcompiler ? true,
  enable-mmdoc ? true,
  enable-numerix ? true,
  enable-analyziz ? true,
  enable-graphix ? true,
  enable-symbolix ? true,
  enable-mmxlight ? true,
  enable-caas ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mathemagix";
  version = "11126";

  src = fetchsvn {
    url = "https://subversion.renater.fr/anonscm/svn/mmx/";
    rev = finalAttrs.version;
    hash = "sha256-AFnYd5oFg/wgaHPjfZmqXNljEpoFW4h6f3UG+KZauEs=";
  };

  strictDeps = true;

  configureFlags = lib.optionals enable-algebramix [
    "--enable-algebramix"
  ] ++ lib.optionals enable-automagix [
    "--enable-automagix"
  ] ++ lib.optionals enable-analyziz [
    "--enable-analyziz"
  ] ++ lib.optionals enable-basix [
    "--enable-basix"
  ] ++ lib.optionals enable-caas [
    "--enable-caas"
  ] ++ lib.optionals enable-graphix [
    "--enable-graphix"
  ] ++ lib.optionals enable-mmcompileregg [
    "--enable-mmcompileregg"
  ] ++ lib.optionals enable-mmcompiler [
    "--enable-mmcompiler"
  ] ++ lib.optionals enable-mmdoc [
    "--enable-mmdoc"
  ] ++ lib.optionals enable-mmxlight [
    "--enable-mmxlight"
  ] ++ lib.optionals enable-numerix [
    "--enable-numerix"
  ] ++ lib.optionals enable-symbolix [
    "--enable-symbolix"
  ];

  buildInputs = [
    gmp
    libtool
    mpfr
    ncurses
    readline
  ];

  nativeBuildInputs = [
    bison
  ];

  preConfigure = ''
    export HOME="$PWD"
  '';

  meta = {
    description = "A free computer algebra and analysis system consisting of a high level language with a compiler and a series of mathematical libraries";
    homepage = "http://www.mathemagix.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
