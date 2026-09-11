{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "shine";
  version = "3.1.1-unstable-2023-01-01";

  src = fetchFromGitHub {
    owner = "toots";
    repo = "shine";
    rev = "ab5e3526b64af1a2eaa43aa6f441a7312e013519";
    hash = "sha256-rlKWVgIl/WVIzwwMuPyWaiwvbpZi5HvKXU3S6qLoN3I=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Fast fixed-point mp3 encoding library";
    mainProgram = "shineenc";
    homepage = "https://github.com/toots/shine";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
