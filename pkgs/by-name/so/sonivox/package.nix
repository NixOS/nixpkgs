{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "3.6.16";

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = "sonivox";
    rev = "v${version}";
    hash = "sha256-2OWlm1GZI08OeiG3AswRyvguv9MUYo1dLo6QUPr3r3s=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/pedrolcl/sonivox";
    description = "MIDI synthesizer library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
}
