{ lib, stdenv, fetchFromGitHub, libGL, libX11, libXext, libXrandr, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "master_me";
  # see: https://github.com/trummerschlunk/master_me/issues/91#issuecomment-1260727551
  version = "unstable-2022-09-28";

  src = fetchFromGitHub {
    owner = "trummerschlunk";
    repo = "master_me";
    rev = "be4b5f2f8c27735464def91121368f9167aee119";
    sha256 = "sha256-/aMYi4Nt3k54GW2YdcautiY5sPnKdaQJcnWAv9loapI=";
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
