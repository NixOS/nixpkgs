{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "corto";
  version = "0-unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "corto";
    rev = "d880519c490c88a39d12c31a914b6a687a7019c3";
    hash = "sha256-0OUijrf+0ZNv3oYko2r8Kp9zgtg8b9RPL7DXHf15Ryc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Mesh compression library, designed for rendering and speed";
    homepage = "https://github.com/cnr-isti-vclab/corto";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
  };
}
