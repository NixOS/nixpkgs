{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, scdoc
, coreutils
, util-linux
, jq
, libnotify
, withHyprland ? true
, hyprland
}:

stdenvNoCC.mkDerivation rec {
  pname = "hdrop";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Schweber";
    repo = "hdrop";
    rev = "v${version}";
    hash = "sha256-IVLc1USBkkIBEll1jRIAAszyGCmpw5Sy74Zyalv3W+w=";
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
    changelog = "https://github.com/Schweber/hdrop/releases/tag/v${version}";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Schweber ];
    mainProgram = "hdrop";
  };
}
