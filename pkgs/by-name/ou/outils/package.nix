{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "outils";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "outils";
    rev = "v${version}";
    hash = "sha256-FokJytwQsbGsryBzyglpb1Hg3wti/CPQTOfIGIz9ThA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/outils";
    description = "Port of OpenBSD-exclusive tools such as `calendar`, `vis`, and `signify`";
    license = with licenses; [
      beerware
      bsd2
      bsd3
      bsdOriginal
      isc
      mit
      publicDomain
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ somasis ];
  };
}
