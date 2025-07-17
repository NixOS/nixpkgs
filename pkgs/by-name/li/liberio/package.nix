{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  systemd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liberio";
  version = "unstable-2019-12-11";

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "liberio";
    rev = "81777e500d1c3b88d5048d46643fb5553eb5f786";
    sha256 = "1n40lj5g497mmqh14vahdhy3jwvcry2pkc670p4c9f1pggp6ysgk";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    systemd
  ];

  doCheck = true;

  meta = with lib; {
    description = "Ettus Research DMA I/O Library";
    homepage = "https://github.com/EttusResearch/liberio";
    license = licenses.gpl2;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.all;
  };
})
