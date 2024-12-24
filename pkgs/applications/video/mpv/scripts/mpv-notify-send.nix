{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  libnotify,
}:

buildLua rec {
  pname = "mpv-notify-send";
  version = "0-unstable-2024-07-11";

  src = fetchFromGitHub {
    owner = "Parranoh";
    repo = "mpv-notify-send";
    rev = "d98d9fe566b222c5b909e3905e9e201eaec34959";
    hash = "sha256-H8WIKfQnle27eiwnz2sxC8D1EwQplY4N7Qg5+c1e/uU=";
  };

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ libnotify ])
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Lua script for mpv to send notifications with notify-send";
    homepage = "https://github.com/Parranoh/mpv-notify-send";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ r3n3gad3p3arl ];
  };
}
