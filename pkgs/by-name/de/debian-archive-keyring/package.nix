{ lib
, stdenvNoCC
, fetchFromGitLab
, gnupg
, jetring
, debian-archive-keyring
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "debian-archive-keyring";
  version = "2023.4";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "release-team";
    repo = "debian-archive-keyring";
    rev = "${finalAttrs.version}";
    hash = "sha256-RjHC4AJ0xyVmELVjX/WBmZYsKWFqcg8F5j+9+18jwj4=";
  };

  nativeBuildInputs = [
    gnupg
    jetring
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  meta = {
    homepage = "https://packages.debian.org/sid/debian-archive-keyring";
    description = "GnuPG archive keys of the Debian archive";
    license = with lib.licenses; [ publicDomain ];
    maintainers = with lib.maintainers; [ MakiseKurisu ];
    platforms = lib.platforms.all;
  };
})
