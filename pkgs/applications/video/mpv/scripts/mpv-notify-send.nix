{
  lib,
  buildLua,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  libnotify,
}:

buildLua rec {
  pname = "mpv-notify-send";
  version = "0-unstable-2020-02-24";

  src = fetchFromGitHub {
    owner = "emilazy";
    repo = pname;
    rev = "a2bab8b2fd8e8d14faa875b5cc3a73f1276cd88a";
    sha256 = "sha256-EwVkhyB87TJ3i9xJmmZMSTMUKvfbImI1S+y1vgRWbDk=";
  };

  patches = [
    # show title of online videos instead of url
    (fetchpatch {
      url = "https://github.com/emilazy/mpv-notify-send/pull/6.patch";
      hash = "sha256-7aXQ8qeqG4yX0Uyn09xCIESnwPZsb6Frd7C49XgbpFw=";
    })
  ];

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath libnotify)
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Lua script for mpv to send notifications with notify-send";
    homepage = "https://github.com/emilazy/mpv-notify-send";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ r3n3gad3p3arl ];
  };
}
