{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  perfetto,
}:

let
  perfetto_old = perfetto.overrideAttrs (oldAttrs: {
    version = "22.1"; # Version can be found at: https://github.com/olvaffe/percetto/blob/<tag>/subprojects/perfetto.wrap#L5

    src = oldAttrs.src.overrideAttrs {
      hash = "sha256-yGIzlIlybM73lsuVK4RhzGnSuJMES3bVETPjWfhA208=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "percetto";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "olvaffe";
    repo = "percetto";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-a8ScDj+TwmUc4IANPLgwdGv0QiezW4mDHxPzjzkek0c=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];
  buildInputs = [ perfetto_old ];

  mesonFlags = [
    (lib.mesonOption "perfetto-sdk" "${perfetto_old.src}/sdk")
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=redundant-move";
})
