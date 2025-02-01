{
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "dotconf";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "dotconf";
    rev = "v${version}";
    sha256 = "sha256-6Du26Ffz08DLGg6uIiPi8Sgjf691MM2kn0qXe3oFeTw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Configuration parser library";
    maintainers = with maintainers; [ pSub ];
    homepage = "https://github.com/williamh/dotconf";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
  };
}
