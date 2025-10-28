{
  lib,
  stdenv,
  fetchFromGitHub,
  libmrss,
}:

stdenv.mkDerivation (final: {
  pname = "rsstail";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "rsstail";
    rev = "v${final.version}";
    hash = "sha256-wbdf9zhwMN7QhJ5WoJo1Csu0EcKUTON8Q2Ic5scbn7I=";
  };

  buildInputs = [ libmrss ];

  makeFlags = [ "prefix=$(out)" ];
  enableParallelBuilding = true;

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  # just runs cppcheck linter
  doCheck = false;

  meta = with lib; {
    description = "Monitor RSS feeds for new entries";
    mainProgram = "rsstail";
    longDescription = ''
      RSSTail is more or less an RSS reader: it monitors an RSS feed and if it
      detects a new entry it'll emit only that new entry.
    '';
    homepage = "https://www.vanheusden.com/rsstail/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.Necior ];
    platforms = platforms.unix;
  };
})
