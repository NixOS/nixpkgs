{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kplex";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "stripydog";
    repo = "kplex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sps9l238hGLJ673kewFH8fOJw0HphEkZbJ+VUIzxC+o=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 0555 kplex $out/bin/kplex

    runHook postInstall
  '';

  meta = with lib; {
    description = "A multiplexer for various nmea 0183 interfaces";
    homepage = "https://www.stripydog.com/kplex/";
    changelog = "https://www.stripydog.com/kplex/changes.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mabster314 ];
    mainProgram = "kplex";
  };
})
