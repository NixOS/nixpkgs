{ lib, stdenv, fetchFromGitHub, libGL, libX11, libXext, libXrandr, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "master_me";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trummerschlunk";
    repo = "master_me";
    rev = version;
    sha256 = "sha256-FG3X1dOF9KRHHSnd5/zP+GrYCB2O0y+tnI5/l9tNhyE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libGL libX11 libXext libXrandr
  ];

  postPatch = ''
    patchShebangs ./dpf/utils/
    substituteInPlace ./dpf/utils/res2c.py \
      --replace '/usr/bin/env python3' ${python3.interpreter}
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://github.com/trummerschlunk/master_me";
    description = "automatic mastering plugin for live streaming, podcasts and internet radio.";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
