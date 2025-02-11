{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "3.6.15";

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-k+EhhLFp+ehptjDS8ZHvo5tfFxmSCA2lFTjkWFLi+cs=";
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
