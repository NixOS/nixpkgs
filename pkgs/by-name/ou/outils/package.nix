{
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/leahneukirchen/outils/commit/50877e1bf7c905044e0b50b227ecff48cfec394b.patch?full_index=1";
      name = "outils-add-recallocarray-prototype.patch";
      hash = "sha256-jOnCMPcHKMRR3J0Yh+ZTHAn7P85FO80yXVX0K2vtlVk=";
    })
  ];

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
