{ stdenv, lib, fetchFromGitHub, cmake, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "unstable-2023-08-04";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.4-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "09ef1be66397873516c799b4ec070690ff7365b2";
    hash = "sha256-DlEbU7uAcQOiBf7QS/1kiw3E0nk3xKhlzhAi8buQNCI=";
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
