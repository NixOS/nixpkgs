{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  makeWrapper,
  withPulseaudio ? false,
  pulseaudio,
}:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-mMcY5TatVHSAsB1E9rcpMh4/yX7j6alZX6ed0yVHFn4=";
  };

  cargoHash = "sha256-fr4hzKDU1n/nSn1Sn7SoI/ZMYm7VU884Rl3Vx+aXInY=";

  # don't build swayr
  buildAndTestSubdir = pname;

  nativeBuildInputs = [ makeWrapper ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = lib.optionals withPulseaudio ''
    wrapProgram "$out/bin/swayrbar" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ pulseaudio ]}"
  '';

  meta = with lib; {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sebtm ];
    mainProgram = "swayrbar";
  };
}
