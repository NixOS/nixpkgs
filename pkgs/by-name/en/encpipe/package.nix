{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "encpipe";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "encpipe";
    rev = version;
    hash = "sha256-YlEKSWzZuQyDi0mbwJh9Dfn4gKiOeqihSHPt4yY6YdY=";
    fetchSubmodules = true;
  };

  installFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Encryption tool";
    homepage = "https://github.com/jedisct1/encpipe";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "encpipe";
  };
}
