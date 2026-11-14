{
  lib,
  stdenv,
  fetchFromGitHub,
  libfaketime,
  mkfontscale,
  fonttosfnt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "creep";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "romeovs";
    repo = "creep";
    rev = finalAttrs.version;
    hash = "sha256-FukN+DdRbw7ujUNClDbtlMRh1iLnv+bkQAgHaP8MQn8=";
  };

  nativeBuildInputs = [
    libfaketime
    fonttosfnt
    mkfontscale
  ];

  buildPhase = ''
    faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -o creep.otb creep.bdf
  '';

  installPhase = ''
    install -D -m644 creep.otb creep.bdf -t "$out/share/fonts/misc/"
    mkfontdir "$out/share/fonts/misc"
  '';

  meta = {
    description = "Pretty sweet 4px wide pixel font";
    homepage = "https://github.com/romeovs/creep";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
