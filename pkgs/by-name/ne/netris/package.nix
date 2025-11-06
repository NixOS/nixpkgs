{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "netris";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "naclander";
    repo = "netris";
    rev = "6773c9b2d39a70481a5d6eb5368e9ced6229ad2b";
    sha256 = "0gmxbpn50pnffidwjchkzph9rh2jm4wfq7hj8msp5vhdq5h0z9hm";
  };

  patches = [
    # https://github.com/naclander/netris/pull/1
    ./configure-fixes-for-gcc-14.patch
  ];

  buildInputs = [
    ncurses
  ];

  configureScript = "./Configure";
  dontAddPrefix = true;

  configureFlags = [
    "--cc"
    "${stdenv.cc.targetPrefix}cc"
    "-O2"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./netris $out/bin
  '';

  meta = with lib; {
    description = "Free networked version of T*tris";
    mainProgram = "netris";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ patryk27 ];
    platforms = platforms.unix;
  };
}
