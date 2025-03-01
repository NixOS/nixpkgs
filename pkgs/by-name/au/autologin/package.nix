{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pam,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "autologin";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "autologin";
    rev = version;
    hash = "sha256-Cy4v/1NuaiSr5Bl6SQMWk5rga8h1QMBUkHpN6M3bWOc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];
  buildInputs = [ pam ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run a command inside of a new PAM user session";
    homepage = "https://sr.ht/~kennylevinsen/autologin";
    changelog = "https://git.sr.ht/~kennylevinsen/autologin/refs/${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ beviu ];
    mainProgram = "autologin";
  };
}
