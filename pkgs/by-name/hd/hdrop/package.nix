{
  coreutils,
  fetchFromGitHub,
  gawk,
  hyprland,
  jq,
  lib,
  libnotify,
  makeWrapper,
  scdoc,
  stdenvNoCC,
  util-linux,
  withHyprland ? true,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hdrop";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "Schweber";
    repo = "hdrop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JlfSGJBN3aJnZcN8aY464mmADP5boenGQzOxv2sswGc=";
  };

  nativeBuildInputs = [
    makeWrapper
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/hdrop --prefix PATH ':' \
      "${
        lib.makeBinPath (
          [
            coreutils
            util-linux
            jq
            libnotify
            gawk
          ]
          ++ lib.optional withHyprland hyprland
        )
      }"
  '';

  meta = {
    description = "Emulate 'tdrop' in Hyprland (run, show and hide specific programs per keybind)";
    homepage = "https://github.com/Schweber/hdrop";
    changelog = "https://github.com/Schweber/hdrop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Schweber ];
    mainProgram = "hdrop";
  };
})
