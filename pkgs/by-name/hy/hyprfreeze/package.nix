{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  jq,
  procps,
  psmisc,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "hyprfreeze";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Zerodya";
    repo = "hyprfreeze";
    tag = "v${version}";
    hash = "sha256-omwAWBEnb14ZBux7bvXSJyi7FI1LZ5GaZFn46/bWJA4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hyprfreeze $out/bin/hyprfreeze

    # Install shell completions
    install -Dm444 completions/bash/hyprfreeze $out/share/bash-completion/completions/hyprfreeze
    install -Dm444 completions/zsh/_hyprfreeze $out/share/zsh/site-functions/_hyprfreeze
    install -Dm444 completions/fish/hyprfreeze.fish $out/share/fish/completions/hyprfreeze.fish

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/hyprfreeze \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          procps
          psmisc
          libnotify
        ]
      }
  '';

  meta = {
    description = "Utility to suspend a game process (and other programs) in Hyprland";
    homepage = "https://github.com/Zerodya/hyprfreeze";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zerodya ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprfreeze";
  };
}
