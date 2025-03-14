{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bshapr";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BShapr";
    rev = "v${version}";
    sha256 = "sha256-9I4DPRl6i/VL8Etw3qLGZkP45BGsbxFxNOvRy3B3I+M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    cairo
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BShapr";
    description = "Beat / envelope shaper LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
