{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "7.1.6";
  pname = "multitail";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "multitail";
    rev = finalAttrs.version;
    hash = "sha256-L8rpuiZrwWkAHIntTwqepVBYTcMuV494lFoS5YvJq8g=";
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

  meta = {
    homepage = "https://github.com/folkertvanheusden/multitail";
    description = "tail on steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    mainProgram = "multitail";
  };
})
