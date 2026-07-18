{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
  bashNonInteractive,
  grim,
  slurp,
  wl-clipboard,
  libnotify,
  wayfreeze,
  satty,
  gpu-screen-recorder,
  ffmpeg,
  quickshell,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "msnap";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "xtheeq";
    repo = "msnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iy15f5dPO3WC/W1avDNYQdFERSXHxwH7ZrpUcIFeLhw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashNonInteractive ];

  dontConfigure = true;

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc/xdg"
    "LOCALSTATEDIR=$(out)/var/lib"
  ];

  postInstall = ''
    wrapProgram "$out/bin/msnap" \
      --prefix PATH : ${
        lib.makeBinPath [
          grim
          slurp
          wl-clipboard
          libnotify
          wayfreeze
          satty
          gpu-screen-recorder
          ffmpeg
          quickshell
        ]
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screenshot and screencast utility for mango";
    homepage = "https://github.com/xtheeq/msnap";
    changelog = "https://github.com/xtheeq/msnap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yvnth ];
    platforms = lib.platforms.linux;
    mainProgram = "msnap";
  };
})
