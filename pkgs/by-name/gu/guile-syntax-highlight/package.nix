{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
}:
stdenv.mkDerivation {
  pname = "guile-syntax-highlight";
  version = "unstable-2023-10-30";

  src = fetchgit {
    url = "https://git.dthompson.us/guile-syntax-highlight.git";
    rev = "e40cc75f93aedf52d37c8b9e4f6be665e937e21d";
    hash = "sha256-tZzE3LnE0pb54ouwj80Zobu/TO+0NzU+2D/2xlG7Gkc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    guile
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = with lib; {
    homepage = "https://dthompson.us/projects/guile-syntax-highlight.html";
    description = "General purpose syntax highlighting for Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [abbe];
    platforms = guile.meta.platforms;
  };
}
