{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ear2ctl";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "bharadwaj-raju";
    repo = "ear2ctl";
    rev = version;
    hash = "sha256-xaxl4opLMw9KEDpmNcgR1fBGUqO4BP5a/U52Kz+GAvc=";
  };

  cargoHash = "sha256-ax+/lvdEOjLnwE3Gvji7aaeF9KXjoOXdlTvxYDo8wGI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux controller for the Nothing Ear (2)";
    homepage = "https://gitlab.com/bharadwaj-raju/ear2ctl";
    maintainers = with lib.maintainers; [ jaredmontoya ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ear2ctl";
  };
}
