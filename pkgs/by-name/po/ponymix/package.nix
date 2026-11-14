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
    hash = "sha256-Kwc9z1DhgAnsNYKmAovKCxgKYv47i+5Lv6b+mq871yM=";
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
