{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchFromGitHub }:

let version = "0.6.0"; in

mkDerivation {
  name = "latte-dock-${version}";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = "Latte-Dock";
    rev = "v${version}";
    sha256 = "1967hx4lavy96vvik8d5m2c6ycd2mlf9cmhrv40zr0784ni0ikyv";
  };

  buildInputs = [ plasma-framework xorg.libpthreadstubs xorg.libXdmcp ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = https://github.com/psifidotos/Latte-Dock;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley ];
  };
}
