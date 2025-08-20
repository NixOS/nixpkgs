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
  version = "0.4.2";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-qfk4yqJkqTiFKFZXCVPPZM0g0/+A8d8fDeat9ZsfokI=";
  };

  cargoHash = "sha256-+YhBwQWDxjS8yAS/+uX7I72qNad9N/xQCVr4QHp+kyw=";

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
    maintainers = with maintainers; [ ];
    mainProgram = "swayrbar";
  };
}
