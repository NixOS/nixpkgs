{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "massdns";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "blechschmidt";
    repo = "massdns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wauwb1+/8rLK5OpgUcRSwI/xUymAIo1Amf2FvEBgXfE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "High-performance DNS stub resolver for bulk lookups and reconnaissance";
    homepage = "https://github.com/blechschmidt/massdns";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ galaxy ];
    platforms = platforms.linux;
  };
})
