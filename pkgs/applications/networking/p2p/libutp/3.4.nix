{ stdenv, lib, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.4-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "490874c44a2ecf914404b0a20e043c9755fff47b";
    hash = "sha256-ArUOr392s/rIplthSmHYXnqhO6i1PkkGV1jmQPQL7Yg=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = unstableGitUpdater {
      branch = "post-3.4-transmission";
    };
  };

  meta = with lib; {
    description = "uTorrent Transport Protocol library";
    mainProgram = "ucat";
    homepage = "https://github.com/transmission/libutp";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
