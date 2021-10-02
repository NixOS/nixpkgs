{ lib, stdenv, fetchFromGitHub, fetchpatch, boost, libpulseaudio, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "pamixer";
  version = "unstable-2021-03-29";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = "4ea2594cb8c605dccd00a381ba19680eba368e94";
    sha256 = "sha256-kV4wIxm1WZvqqyfmgQ2cSbRJwJR154OW0MMDg2ntf6g=";
  };

  buildInputs = [ boost libpulseaudio ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pamixer -t $out/bin

    runHook postInstall
  '';

  postInstall = ''
    installManPage pamixer.1
  '';

  meta = with lib; {
    description = "Pulseaudio command line mixer";
    longDescription = ''
      Features:
        - Get the current volume of the default sink, the default source or a selected one by its id
        - Set the volume for the default sink, the default source or any other device
        - List the sinks
        - List the sources
        - Increase / Decrease the volume for a device
        - Mute or unmute a device
    '';
    homepage = "https://github.com/cdemoulins/pamixer";
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "pamixer";
  };
}
