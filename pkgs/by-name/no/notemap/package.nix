{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  libressl,
  memstreamHook,
}:

stdenv.mkDerivation rec {
  pname = "notemap";
  version = "1.3";

  src = fetchzip {
    url = "https://git.causal.agency/notemap/snapshot/notemap-${version}.tar.gz";
    sha256 = "0s9c1xx0iggyzclqw3294bjv7qgvd5l5zgbryks4hvfibr73r6ps";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libressl
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      memstreamHook
    ];

  meta = {
    description = "Mirror notes to IMAP";
    longDescription = ''
      notemap(1) mirrors text files to an IMAP mailbox in a format compatible with the iOS
      Notes app. It's intended to make notes managed in git(1) easily accessible
      from the phone.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://git.causal.agency/notemap/about/";
    platforms = lib.platforms.unix;
  };
}
