{ stdenv
, lib
, fetchFromGitHub
, makeShellWrapper
, wrapQtAppsHook
, cmake
, qtbase
, qtwebengine
, knotifications
, kxmlgui
, kglobalaccel
, pipewire
, bash
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    sha256 = "sha256-it7JSmiDz3k1j+qEZrrNhyAuoixiQuiEbXac7lbJmko=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeShellWrapper
    wrapQtAppsHook
    cmake
    qtbase
    qtwebengine
    knotifications
    kxmlgui
  ];

  buildInputs = [
    kglobalaccel
    pipewire
    bash
    xdg-desktop-portal
  ];

  cmakeFlags = [
    "-DPipeWire_INCLUDE_DIRS=${pipewire.dev}/include/pipewire-0.3"
    "-DSpa_INCLUDE_DIRS=${pipewire.dev}/include/spa-0.2"
  ];

  dontWrapQtApps = true;

  # Make sure kglobalaccel is running for keybinds to work
  postFixup = ''
    wrapProgramShell $out/bin/discord-screenaudio \
      ''${qtWrapperArgs[@]} \
      --run "${kglobalaccel}/bin/kglobalaccel5 &"
  '';

  meta = with lib; {
    description = "Discord client that supports streaming with audio on Linux";
    longDescription = "Requires Pipewire, it currently doesn't work with PulseAudio. It can only share primary screen on X11.";
    homepage = "https://github.com/maltejur/discord-screenaudio";
    changelog = "https://github.com/maltejur/discord-screenaudio/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ heyimnova ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
    mainProgram = "discord-screenaudio";
  };
}
