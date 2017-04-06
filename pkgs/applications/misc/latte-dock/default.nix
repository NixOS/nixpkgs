{ stdenv, lib, cmake, plasma-framework, fetchFromGitHub }:

let version = "0.5.98"; in

stdenv.mkDerivation {
  name = "latte-dock-${version}";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "Latte-Dock";
    rev = version;
    sha256 = "0z02ipbbv0dmcxs2g3dq5h62klhijni1i4ikq903hjg0j2cqg5xh";
  };

  buildInputs = [ plasma-framework ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = https://github.com/psifidotos/Latte-Dock;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley ];
  };
}
