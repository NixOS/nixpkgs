{
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "distro-info-data";
  version = "0.67";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "distro-info-data";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-xm/ajsPKtnmuyEkVxM1AxV7Tl0njkqjOmhE5rKRQ36Q=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Information about Debian and Ubuntu releases";
    homepage = "https://salsa.debian.org/debian/distro-info-data";
    changelog = "https://salsa.debian.org/debian/distro-info-data/-/blob/${finalAttrs.src.tag}/debian/changelog";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.all;
  };
})
