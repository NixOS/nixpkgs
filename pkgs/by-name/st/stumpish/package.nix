{
  lib,
  stdenv,
  replaceVars,
  fetchFromGitHub,
  gnused,
  ncurses,
  xprop,
  rlwrap,
}:

stdenv.mkDerivation {
  pname = "stumpish";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "stumpwm";
    repo = "stumpwm-contrib";
    rev = "9f5f06652c480159ec57d1fd8751b16f02db06dc";
    hash = "sha256-1FnyKuLM02Bh3dF+VlPmHiiWMgIaiSA8uqiEkaPVv7c=";
  };

  buildInputs = [
    gnused
    xprop
    rlwrap
    ncurses
  ];

  patches = [
    (replaceVars ./paths.patch {
      sed = "${gnused}/bin/sed";
      xprop = "${xprop}/bin/xprop";
      rlwrap = "${rlwrap}/bin/rlwrap";
      tput = "${ncurses}/bin/tput";
    })
  ];

  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    cp util/stumpish/stumpish $out/bin
  '';

  meta = {
    homepage = "https://github.com/stumpwm/stumpwm-contrib";
    description = "STUMPwm Interactive SHell";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "stumpish";
  };
}
