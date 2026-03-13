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
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    tag = "swayrbar-${version}";
    sha256 = "sha256-uT8MYgH9kANQ0t+7jqjOOvQIZf5ImdQruZLLlCejwcc=";
  };

  cargoHash = "sha256-Aj4U2xyfNhf3HDSEd1SQ5TyO2MXn2/hrfnG0ZayzMtU=";

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

  meta = {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    changelog = "https://git.sr.ht/~tsdh/swayr/tree/main/item/swayrbar/NEWS.md";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ilkecan ];
    mainProgram = "swayrbar";
  };
}
