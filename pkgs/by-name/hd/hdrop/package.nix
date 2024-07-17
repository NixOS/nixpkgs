{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  scdoc,
  coreutils,
  util-linux,
  jq,
  libnotify,
  withHyprland ? true,
  hyprland,
  gawk,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hdrop";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Schweber";
    repo = "hdrop";
    rev = "v${version}";
    hash = "sha256-iginpMlgANSPWgFxNC2TYMjf2NKSSzzrjIN8lIsAvX8=";
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

  meta = with lib; {
    description = "Emulate 'tdrop' in Hyprland (run, show and hide specific programs per keybind)";
    homepage = "https://github.com/Schweber/hdrop";
    changelog = "https://github.com/Schweber/hdrop/releases/tag/v${version}";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Schweber ];
    mainProgram = "hdrop";
  };
}
