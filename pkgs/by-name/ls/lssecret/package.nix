{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "lssecret";
  version = "unstable-2022-12-02";

  src = fetchFromGitLab {
    owner = "GrantMoyer";
    repo = "lssecret";
    rev = "20fd771a";
    hash = "sha256-yU70WZj4EC/sFJxyq2SQ0YQ6RCQHYiW/aQiYWo7+ujk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Tool to list passwords and other secrets stored using the org.freedesktop.secrets dbus api";
    homepage = "https://gitlab.com/GrantMoyer/lssecret";
    license = licenses.unlicense;
    maintainers = with maintainers; [ genericnerdyusername ];
    platforms = platforms.unix;
    mainProgram = "lssecret";
  };
}
