{ lib, stdenv, fetchFromGitHub, xorg }:

stdenv.mkDerivation rec {
  pname = "xmountains";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "spbooth";
    repo = pname;
    rev = "aa3bcbfed228adf3fff0fe4295589f13fc194f0b";
    sha256 = "0dx4n2y736lv04sj41cp1dw8n5zkw5gyd946a6zsiv0k796s9ra9";
  };

  buildInputs = [ xorg.xbitmaps xorg.libX11 ];
  nativeBuildInputs = with xorg; [ imake gccmakedep ];

  installPhase = "install -Dm755 xmountains -t $out/bin";

  meta = with lib; {
    description = "X11 based fractal landscape generator";
    homepage = "https://spbooth.github.io/xmountains";
    license = licenses.hpndSellVariant;
    maintainers = with maintainers; [ djanatyn ];
  };
}
