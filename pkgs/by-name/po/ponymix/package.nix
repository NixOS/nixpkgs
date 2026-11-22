{
  lib,
  stdenv,
  fetchFromGitHub,
  libpulseaudio,
  libnotify,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ponymix";
  version = "5";

  src = fetchFromGitHub {
    owner = "falconindy";
    repo = "ponymix";
    rev = finalAttrs.version;
    sha256 = "08yp7fprmzm6px5yx2rvzri0l60bra5h59l26pn0k071a37ks1rb";
  };

  buildInputs = [
    libpulseaudio
    libnotify
  ];
  nativeBuildInputs = [ pkg-config ];

  postPatch = ''substituteInPlace Makefile --replace "\$(DESTDIR)/usr" "$out"'';

  meta = {
    description = "CLI PulseAudio Volume Control";
    homepage = "https://github.com/falconindy/ponymix";
    mainProgram = "ponymix";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
