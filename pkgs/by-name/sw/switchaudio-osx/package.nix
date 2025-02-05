{
  lib,
  stdenv,
  fetchFromGitHub,
  xcodebuild,
  xcbuildHook,
}:

stdenv.mkDerivation rec {
  pname = "switchaudio-osx";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "deweller";
    repo = "switchaudio-osx";
    tag = version;
    hash = "sha256-AZJn5kHK/al94ONfIHcG+W0jyMfgdJkIngN+PVj+I44=";
  };

  buildInputs = [ xcodebuild ];

  nativeBuildInputs = [ xcbuildHook ];

  patches = [
    # Patch to fix running on earlier version of macOS
    # https://github.com/deweller/switchaudio-osx/pull/65
    ./001-macos-legacy-support.patch
  ];

  installPhase = ''
    runHook preInstall

    # for some reason binary is located in Products/ rather than in build/
    install -Dm755 Products/Release/SwitchAudioSource $out/bin/SwitchAudioSource

    runHook postInstall
  '';

  meta = {
    description = "Command-line utility to manage audio input/output devices on macOS";
    homepage = "https://github.com/deweller/switchaudio-osx";
    mainProgram = "SwitchAudioSource";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
    platforms = lib.platforms.darwin;
  };
}
