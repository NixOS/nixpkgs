{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "notify-desktop";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "notify-desktop";
    rev = "9863919fb4ce7820810ac14a09a46ee73c3d56cc";
    sha256 = "1brcvl2fx0yzxj9mc8hzfl32zdka1f1bxpzsclcsjplyakyinr1a";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 bin/notify-desktop $out/bin/notify-desktop
  '';

  meta = with lib; {
    description = "Little application that lets you send desktop notifications with one command";
    longDescription = ''
      It's basically clone of notify-send from libnotify,
      but it supports reusing notifications on screen by passing its ID.
      It also does not use any external dependencies (except from libdbus of course).
    '';
    homepage = "https://github.com/nowrep/notify-desktop";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ylwghst ];
    mainProgram = "notify-desktop";
  };
}
