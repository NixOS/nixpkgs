{
  lib,
  flutter341,
  fetchFromGitHub,
  keybinder3,
  libayatana-appindicator,
}:

flutter341.buildFlutterApplication {
  pname = "nyrna";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "Merrit";
    repo = "nyrna";
    rev = "5649b93ee9199de79dfd3706dc11a8e7f829049e";
    hash = "sha256-7L7XqwjWm4fmWGoE9JRwp5jB+3ze5jbR/0JrzPpzPOE=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  preBuild = ''
    packageRun build_runner build --delete-conflicting-outputs
  '';

  meta = {
    description = "Suspend games and applications";
    longDescription = ''
      Nyrna allows to suspend games and applications.
      It's easy-to-use: similar to the suspend mode on consoles, easily suspend
      and resume your PC games with the push of a button.
      It's powerful: Suspend and resume your games with a hotkey for the active
      window or for specific applications, the friendly Material GUI, or the
      CLI interface.
    '';
    homepage = "https://nyrna.merritt.codes/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ynot ];
  };
}
