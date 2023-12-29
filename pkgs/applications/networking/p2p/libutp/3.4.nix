{ stdenv, lib, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2023-10-16";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.4-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "2589200eac82fc91b65979680e4b3c026dff0278";
    hash = "sha256-wsDqdbMWVm3ubTbg5XClEWutJz1irSIazVLFeCyAAL4=";
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
