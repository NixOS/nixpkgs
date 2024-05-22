{
  lib,
  fetchurl,
  libnl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iw";
  version = "5.19";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/iw/iw-${finalAttrs.version}.tar.xz";
    hash = "sha256-8We76UfdU7uevAwdzvXbatc6wdYITyxvk3bFw2DMTU4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnl ];

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  strictDeps = true;

  meta = {
    homepage = "https://wireless.wiki.kernel.org/en/users/Documentation/iw";
    description = "Tool to use nl80211";
    longDescription = ''
      iw is a new nl80211 based CLI configuration utility for wireless devices.
      It supports all new drivers that have been added to the kernel recently.
      The old tool iwconfig, which uses Wireless Extensions interface, is
      deprecated and it's strongly recommended to switch to iw and nl80211.
    '';
    license = lib.licenses.isc;
    mainProgram = "iw";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
