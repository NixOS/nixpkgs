{ stdenv, lib, fetchFromSourcehut, meson, ninja, pkg-config, wayland }:

stdenv.mkDerivation rec {
  pname = "libscfg";
  version = "0.1.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "libscfg";
    rev = "v${version}";
    sha256 = "sha256-aTcvs7QuDOx17U/yP37LhvIGxmm2WR/6qFYRtfjRN6w=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ wayland ];

  meta = with lib; {
    homepage = "https://sr.ht/~emersion/libscfg";
    description = "A simple configuration file format";
    license = licenses.mit;
    maintainers = with maintainers; [ michaeladler ];
    platforms = platforms.linux;
  };
}
