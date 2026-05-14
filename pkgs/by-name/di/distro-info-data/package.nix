{
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "distro-info-data";
  version = "0.69";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "distro-info-data";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-EsIg+ZPTKVXHvvGnwFSgzFfn+h0JTXcYzCP4ewFM5Kc=";
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
