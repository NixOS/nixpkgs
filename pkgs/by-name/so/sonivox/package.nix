{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "3.6.13";

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QhXMmJbyqDxSJmT847Qbg1jbU3gLFsJ/FWVTy7MV2fE=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/pedrolcl/sonivox";
    description = "MIDI synthesizer library";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
