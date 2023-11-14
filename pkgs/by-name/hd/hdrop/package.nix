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
  withHyprland ? true, hyprland
}:

stdenvNoCC.mkDerivation rec {
  pname = "hdrop";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Schweber";
    repo = "hdrop";
    rev = "${version}";
    hash = "sha256-aUL6mZ061rZBah8+/m5Guw23O7YeNK+FZY2obkVTk1I=";
  };

  nativeBuildInputs = [
    makeWrapper
    scdoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/hdrop --prefix PATH ':' \
      "${lib.makeBinPath ([
        coreutils
        util-linux
        jq
        libnotify
      ]
      ++ lib.optional withHyprland hyprland)}"
  '';

  meta = with lib; {
    description = "Emulate 'tdrop' in Hyprland (run, show and hide specific programs per keybind)";
    homepage = "https://github.com/Schweber/hdrop";
    changelog = "https://github.com/Schweber/hdrop/releases/tag/${version}";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Schweber ];
    mainProgram = "hdrop";
  };
}
