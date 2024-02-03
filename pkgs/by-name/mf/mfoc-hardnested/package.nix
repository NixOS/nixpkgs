{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libnfc
, xz
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfoc-hardnested";
  version = "unstable-2023-03-27";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = finalAttrs.pname;
    rev = "a6007437405a0f18642a4bbca2eeba67c623d736";
    hash = "sha256-YcUMS4wx5ML4yYiARyfm7T7nLomgG9YCSFj+ZUg5XZk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libnfc
    xz
  ];

  meta = with lib; {
    description = "A fork of mfoc integrating hardnested code from the proxmark";
    license = licenses.gpl2;
    homepage = "https://github.com/nfc-tools/mfoc-hardnested";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.unix;
  };
})
