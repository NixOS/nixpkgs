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
<<<<<<< HEAD
  version = "0.16.5";
=======
  version = "0.16.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-zBMenewDtUyhOAQrIKejiShGWDeIA+7U1heyOKfAjio=";
=======
    hash = "sha256-r+5rNaBXhHbDWFXbgEPriEmjWEjTyu2I5H7rl3PoF38=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
      ebzzry
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})
