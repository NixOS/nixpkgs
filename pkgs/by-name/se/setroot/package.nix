{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  imlib2,
  pkg-config,
  enableXinerama ? true,
  libxinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.4";
  pname = "setroot";

  src = fetchFromGitHub {
    owner = "ttzhou";
    repo = "setroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kYxBZy1SZkHSwOXbA+zS3x4khOs5xgO3cJp+duxYsVY=";
  };

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
    changelog = "https://github.com/ttzhou/setroot/blob/${finalAttrs.src.tag}/CHANGELOG.asciidoc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.unix;
    mainProgram = "setroot";
  };
})
