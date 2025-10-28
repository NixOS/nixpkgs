{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "flux";
  version = "2013-09-20";

  src = fetchFromGitHub {
    owner = "deniskropp";
    repo = "flux";
    rev = "e45758aa9384b9740ff021ea952399fd113eb0e9";
    sha256 = "11f3ypg0sdq5kj69zgz6kih1yrzgm48r16spyvzwvlswng147410";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Interface description language used by DirectFB";
    mainProgram = "fluxcomp";
    homepage = "https://github.com/deniskropp/flux";
    license = licenses.mit;
  };
}
