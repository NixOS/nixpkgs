{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXi,
  libXrandr,
  txt2man,
}:

stdenv.mkDerivation rec {
  pname = "xlibinput-calibrator";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kreijack";
    repo = "xlibinput_calibrator";
    rev = "v${version}";
    hash = "sha256-MvlamN8WSER0zN9Ru3Kr2MFARD9s7PYKkRtyD8s6ZPI=";
  };

  nativeBuildInputs = [
    txt2man
  ];

  buildInputs = [
    libX11
    libXi
    libXrandr
  ];

  installFlags = [ "prefix=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Touch calibrator for libinput";
    mainProgram = "xlibinput_calibrator";
    homepage = "https://github.com/kreijack/xlibinput_calibrator";
    changelog = "https://github.com/kreijack/xlibinput_calibrator/blob/${src.rev}/Changelog";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ atemu ];
  };
}
