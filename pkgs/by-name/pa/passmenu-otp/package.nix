{
  stdenv,
  lib,
  pkgs,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "passmenu-otp";
  version = "0-unstable-2019-04-21";

  src = fetchFromGitHub {
    owner = "petrmanek";
    repo = "passmenu-otp";
    rev = "2623a0845cc2bb68b636a743862693fce9ec8b02";
    hash = "sha256-2EGomeK/p3uVfgho5xGR11ovJQ2q3cPZoFG+z88DyxA=";
  };

  buildInputs = with pkgs; [
    dmenu
    pass
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp passmenu-otp $out/bin
    chmod +x $out/bin/passmenu-otp

    runHook postInstall
  '';

  meta = {
    description = "Extension of passmenu, friendly to one-time passwords (OTP)";
    homepage = "https://github.com/petrmanek/passmenu-otp";
    mainProgram = "passmenu-otp";
    maintainers = with lib.maintainers; [ opdavies ];
    platforms = lib.platforms.unix;
  };
}
