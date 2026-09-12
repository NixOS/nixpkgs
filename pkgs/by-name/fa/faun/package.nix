{
  stdenv,
  lib,
  fetchFromCodeberg,
  flac,
  libpulseaudio,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "faun";
  version = "0.2.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "WickedSmoke";
    repo = "faun";
    tag = "v${version}";
    hash = "sha256-fUYKrs4nSIh/l3UQ+PA7F0RJ5hPBd99sjhex7LZ/Lik=";
  };

  buildInputs = [
    flac
    libpulseaudio
    libvorbis
  ];

  # nonstandard configure script: uses '--prefix <dir>' (space) instead of '--prefix=<dir>'
  dontAddPrefix = true;

  postPatch = ''
    patchShebangs configure
  '';

  configureFlags = [
    "--prefix"
    (placeholder "out")
  ];

  meta = {
    homepage = "https://codeberg.org/WickedSmoke/faun";
    description = "High-level C audio library";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ mausch ];
    platforms = with lib.platforms; unix;
  };
}
