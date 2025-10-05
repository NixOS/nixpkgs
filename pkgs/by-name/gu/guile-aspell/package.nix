{
  lib,
  stdenv,
  fetchFromGitHub,
  guile,
  autoreconfHook,
  pkg-config,
  aspell,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-aspell";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "spk121";
    repo = "guile-aspell";
    rev = finalAttrs.version;
    hash = "sha256-CvLECZLwf4MujAQCL3I81O5xFvq6ezVhV0BjbqI3mR0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    aspell
  ];

  meta = with lib; {
    description = "Guile bindings for the aspell library";
    homepage = "https://github.com/spk121/guile-aspell";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = guile.meta.platforms;
  };
})
