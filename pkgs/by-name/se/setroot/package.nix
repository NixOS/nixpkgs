{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  imlib2,
  pkg-config,
  fetchpatch,
  enableXinerama ? true,
  libxinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.2";
  pname = "setroot";

  src = fetchFromGitHub {
    owner = "ttzhou";
    repo = "setroot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uAaBmR8MFrs9VFX6XZW/nRt8yWXKzSLXmfRqsJFAJXE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ttzhou/setroot/commit/d8ff8edd7d7594d276d741186bf9ccf0bce30277.patch";
      sha256 = "sha256-e0iMSpiOmTOpQnp599fjH2UCPU4Oq1VKXcVypVoR9hw=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    imlib2
  ]
  ++ lib.optionals enableXinerama [ libxinerama ];

  buildFlags = [ (if enableXinerama then "xinerama=1" else "xinerama=0") ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple X background setter inspired by imlibsetroot and feh";
    homepage = "https://github.com/ttzhou/setroot";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "setroot";
  };
})
