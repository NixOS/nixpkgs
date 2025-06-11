{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "sfsexp";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "mjsottile";
    repo = "sfsexp";
    rev = "v${version}";
    sha256 = "sha256-uAk/8Emf23J0D3D5+eUEpWLY2fIvdQ7a80eGe9i1WQ8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Small Fast S-Expression Library";
    homepage = "https://github.com/mjsottile/sfsexp";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
