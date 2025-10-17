# Note: this is rakshasa's version of libtorrent, used mainly by rtorrent.
# *Do not* mistake it by libtorrent-rasterbar, used by Deluge, qbitttorent etc.
{
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rakshasa";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dVKd9u7etLhaNKrtedtIFsUgJ+KuP/vCFn1skY/wZeY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    curl
    pkg-config
  ];

  buildInputs = [
    cppunit
    openssl
    zlib
  ];

  configureFlags = [ "--enable-aligned=yes" ];

  passthru.updateScript = nix-update-script { };

  enableParallelBuilding = true;

  meta = {
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    homepage = "https://github.com/rakshasa/libtorrent";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ebzzry
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})
