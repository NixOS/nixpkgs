{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fbvnc";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "zohead";
    repo = pname;
    rev = "783204ff6c92afec33d6d36f7e74f1fcf2b1b601";
    hash = "sha256-oT7+6kIeFDgU6GbcHYQ6k0jCU84p8fTEVgUozYMkeVI=";
  };

  makeFlags = [
    "CC:=$(CC)"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 fbvnc     -t "$out/bin"
    install -Dm444 README.md -t "$out/share/doc/fbvnc"

    runHook postInstall
  '';

  meta = {
    description = "Framebuffer VNC client";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zohead/fbvnc/";
    mainProgram = "fbvnc";
  };
}
