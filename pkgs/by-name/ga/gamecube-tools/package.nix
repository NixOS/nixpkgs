{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  freeimage,
  libGL,
}:

stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "gamecube-tools";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    freeimage
    libGL
  ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo = "gamecube-tools";
    rev = "v${version}";
    sha256 = "sha256-GsTmwyxBc36Qg+UGy+cRAjGW1eh1XxV0s94B14ZJAjU=";
  };

  meta = with lib; {
    description = "Tools for gamecube/wii projects";
    homepage = "https://github.com/devkitPro/gamecube-tools/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
