{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, curl
, gtkmm3
, glibmm
, gnutls
, yajl
, pkg-config
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "samrewritten";
  version = "202008-unstable-2023-05-22";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    # The latest release is too old, use latest commit instead
    rev = "39d524a72678a226bf9140db6b97641f554563c3";
    hash = "sha256-sS/lVY5EWXdTOg7cDWPbi/n5TNt+pRAF1x7ZEaYG4wM=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    gtkmm3
    glibmm
    gnutls
    yajl
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Steam Achievement Manager For Linux. Rewritten in C++";
    mainProgram = "samrewritten";
    homepage = "https://github.com/PaulCombal/SamRewritten";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = [ "x86_64-linux" ];
  };
})
