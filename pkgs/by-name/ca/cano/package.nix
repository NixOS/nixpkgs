{ stdenv
, lib
, fetchFromGitHub
, gnumake
, ncurses
}:
stdenv.mkDerivation (finalAttrs: {
  name = "cano";
  version = "0.1.0-alpha";

  src = fetchFromGitHub {
    owner = "CobbCoding1";
    repo = "Cano";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BKbBDN7xZwlNzw7UFgX+PD9UXbr9FtELo+PlbfSHyRY=";
  };

  buildInputs = [ gnumake ncurses ];
  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/cano $out/bin
  '';

  meta = {
     description = "Text Editor Written In C Using ncurses";
     homepage = "https://github.com/CobbCoding1/Cano";
     license = lib.licenses.asl20;
     mainProgram = "Cano";
     maintainers = with lib.maintainers; [ sigmanificient ];
     platforms = lib.platforms.linux;
  };
})
