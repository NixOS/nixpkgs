{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, libevdev
, json-glib
, libinput
, gtk4
, wrapGAppsHook4
, libxkbcommon
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "showmethekey";
<<<<<<< HEAD
  version = "1.8.1";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IfegYHHFbZbMTA8JWXAun9Gl3BpykH/5RqUIrlYlLhk=";
=======
    hash = "sha256-iWZjOhugGD7GikcIKaJimfLrTDaGQeYgmp17N03Meb8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    json-glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libevdev
    libinput
    libxkbcommon
  ];

  meta = with lib; {
    homepage = "https://showmethekey.alynx.one/";
    description = "Show keys you typed on screen";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocfox ];
  };
}
