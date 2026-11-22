{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  python3,
  playerctl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lyricspot";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "vlensys";
    repo = "lyricspot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qDXTcTlpMWW7vAQuOFBEnM26DvIdy/fvkGTL/TdDa2A=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp lyricspot.py $out/bin/lyricspot
    chmod +x $out/bin/lyricspot
    wrapProgram $out/bin/lyricspot \
      --prefix PATH ":" ${
        lib.makeBinPath [
          python3
          playerctl
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/vlensys/lyricspot";
    description = "Good old live synced lyrics in your terminal";
    license = lib.licenses.gpl3Only;
    mainProgram = "lyricspot";
    maintainers = with lib.maintainers; [
      yarn
    ];
    platforms = lib.platforms.unix;
  };
})
