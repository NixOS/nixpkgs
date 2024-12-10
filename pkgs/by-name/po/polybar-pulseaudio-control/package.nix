{
  lib,
  bash,
  coreutils,
  fetchFromGitHub,
  gawk,
  makeWrapper,
  pulseaudio,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polybar-pulseaudio-control";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "marioortizmanero";
    repo = "polybar-pulseaudio-control";
    rev = "v${finalAttrs.version}";
    hash = "sha256-egCBCnhnmHHKFeDkpaF9Upv/oZ0K3XGyutnp4slq9Vc=";
  };

  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pulseaudio-control.bash $out/bin/pulseaudio-control
    wrapProgram "$out/bin/pulseaudio-control" \
      --prefix PATH : "${
        lib.makeBinPath [
          bash
          coreutils
          gawk
          pulseaudio
        ]
      }"

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "pulseaudio-control";
    description = "Polybar module to control PulseAudio devices, also known as Pavolume";
    homepage = "https://github.com/marioortizmanero/polybar-pulseaudio-control";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ benlemasurier ];
  };
})
