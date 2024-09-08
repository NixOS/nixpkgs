{
  lib,
  aspell,
  autoreconfHook,
  fetchFromGitHub,
  guile,
  pkg-config,
  stdenv,
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

  outputs = [
    "out"
    "info"
  ];

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  propagatedBuildInputs = [ aspell ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/spk121/guile-aspell";
    description = "Guile bindings for the aspell library";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ snowflake ];
    inherit (guile.meta) platforms;
  };
})
