{
  fetchFromSourcehut,
  gtk3,
  lib,
  libdbusmenu-gtk3,
  pkg-config,
  stdenv,
  vala,
}:

stdenv.mkDerivation rec {
  pname = "snixembed";
  version = "0.3.3";

  src = fetchFromSourcehut {
    owner = "~steef";
    repo = "snixembed";
    rev = version;
    sha256 = "sha256-co32Xlklg6KVyi+xEoDJ6TeN28V+wCSx73phwnl/05E=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
    libdbusmenu-gtk3
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Proxy StatusNotifierItems as XEmbedded systemtray-spec icons";
    homepage = "https://git.sr.ht/~steef/snixembed";
    changelog = "https://git.sr.ht/~steef/snixembed/refs/${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "snixembed";
  };
}
