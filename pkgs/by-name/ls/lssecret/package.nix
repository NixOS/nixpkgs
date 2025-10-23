{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libsecret,
}:

stdenv.mkDerivation {
  pname = "lssecret";
  version = "unstable-2022-12-02";

  src = fetchFromGitLab {
    owner = "GrantMoyer";
    repo = "lssecret";
    rev = "20fd771a678a241abbb57152e3c2d9a8eee353cb";
    hash = "sha256-yU70WZj4EC/sFJxyq2SQ0YQ6RCQHYiW/aQiYWo7+ujk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Tool to list passwords and other secrets stored using the org.freedesktop.secrets dbus api";
    homepage = "https://gitlab.com/GrantMoyer/lssecret";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ genericnerdyusername ];
    platforms = lib.platforms.unix;
    mainProgram = "lssecret";
  };
}
