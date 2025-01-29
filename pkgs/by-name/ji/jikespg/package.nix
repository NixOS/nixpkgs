{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "jikespg";
  version = "1.3";

  src = fetchurl {
    url = "mirror://sourceforge/jikes/${pname}-${version}.tar.gz";
    sha256 = "083ibfxaiw1abxmv1crccx1g6sixkbyhxn2hsrlf6fwii08s6rgw";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail "gcc" "${stdenv.cc.targetPrefix}cc ${lib.optionalString stdenv.hostPlatform.isDarwin "-std=c89"}"
  '';

  sourceRoot = "jikespg/src";

  installPhase = ''
    install -Dm755 -t $out/bin jikespg
  '';

  meta = with lib; {
    homepage = "https://jikes.sourceforge.net/";
    description = "Jikes Parser Generator";
    mainProgram = "jikespg";
    platforms = platforms.all;
    license = licenses.ipl10;
    maintainers = with maintainers; [ pSub ];
  };
}
