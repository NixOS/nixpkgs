{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libutp";
  version = "0-unstable-2023-11-14";

  src = fetchFromGitHub {
    # Use transmission fork from post-3.4-transmission branch
    owner = "transmission";
    repo = pname;
    rev = "52645d6d0fb16009e11d2f84469d2e43b7b6b48a";
    hash = "sha256-pcPVkDEEtriN9zlEcVFKwKhhh51wpJGxYlcu7bH1RkI=";
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
