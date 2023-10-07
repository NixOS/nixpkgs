{ stdenv, lib, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2023-03-05";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.4-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "9cb9f9c4f0073d78b08d6542cebaea6564ecadfe";
    hash = "sha256-dpbX1h/gpuVIAXC4hwwuRwQDJ0pwVVEsgemOVN0Dv9Q=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = unstableGitUpdater {
      branch = "post-3.4-transmission";
    };
  };

  meta = with lib; {
    description = "uTorrent Transport Protocol library";
    homepage = "https://github.com/transmission/libutp";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
