{
  lib,
  stdenvNoCC,
  coreutils,
  fetchFromGitHub,
  gnugrep,
  gnused,
  imagemagick,
  makeWrapper,
  nix-update-script,
  procps,
  ruby,
  which,
  xclip,
  xdg-utils,
  xdotool,
  xorg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gyazo";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "gyazo";
    repo = "Gyazo-for-Linux";
    tag = finalAttrs.version;
    hash = "sha256-MW1w/XYleG29vm51F2ObiuoJUL0RhQ/kVSgtFdKP8IM=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ruby ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 src/gyazo.rb $out/bin/gyazo
    install -Dm644 src/gyazo.desktop -t $out/share/applications
    install -Dm644 icons/gyazo.png -t $out/share/pixmaps

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/gyazo \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          imagemagick
          procps
          which
          xclip
          xdg-utils
          xdotool
          xorg.xprop
          xorg.xwininfo
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Gyazo screenshot uploader for Linux";
    homepage = "https://github.com/gyazo/Gyazo-for-Linux";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gyazo";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
