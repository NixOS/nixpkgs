{
  lib,
  gccStdenv,
  fetchurl,
  libbsd,
  libressl,
  pkg-config,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "acme-client";
  version = "1.3.7";

  src = fetchurl {
    url = "https://files.wolfsden.cz/releases/acme-client/acme-client-${finalAttrs.version}.tar.gz";
    hash = "sha256-Mq+6epLcgEnlQ0JAPYCxGQu7EM0VS0Y32PYuvEuliAE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libbsd
    libressl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Secure ACME/Let's Encrypt client";
    homepage = "https://git.wolfsden.cz/acme-client-portable";
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      pmahoney
      kybe236
    ];
    mainProgram = "acme-client";
  };
})
