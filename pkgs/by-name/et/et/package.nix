{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libnotify,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "et";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "oxzi";
    repo = "et";
    rev = finalAttrs.version;
    sha256 = "sha256-mJDRhi7osW4hsNVx3soLYqN9crwU7+kQUolCjqehQT4=";
  };

  buildInputs = [
    libnotify
    gdk-pixbuf
  ];
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    mkdir -p $out/bin
    cp et $out/bin
    cp et-status.sh $out/bin/et-status
  '';

  meta = {
    description = "Minimal libnotify-based (egg) timer";
    homepage = "https://github.com/oxzi/et";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lennartmueh ];
  };
})
