{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation rec {
  version = "7.1.5";
  pname = "multitail";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = pname;
    rev = version;
    hash = "sha256-c9NlQLgHngNBbADZ6/legWFaKHJAQR/LZIfh8bJoc4Y=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    install -Dm755 multitail -t $out/bin/

    runHook postInstall
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/folkertvanheusden/multitail";
    description = "tail on Steroids";
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
    license = licenses.asl20;
    mainProgram = "multitail";
  };
}
