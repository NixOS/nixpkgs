{ stdenv, lib, fetchFromGitHub, makeWrapper
, pkg-config, which, perl, jq, libXrandr
, cairo, dbus, systemd, gdk-pixbuf, glib, libX11, libXScrnSaver
, wayland, wayland-protocols
, libXinerama, libnotify, pango, xorgproto, librsvg
, testers, dunst
}:

stdenv.mkDerivation rec {
  pname = "dunst";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "sha256-oCeC/rbI/sydcQ7Rv9feEzw2Gcl7mUde4OOv50dyUSg=";
  };

  nativeBuildInputs = [ perl pkg-config which systemd makeWrapper ];

  buildInputs = [
    cairo dbus gdk-pixbuf glib libX11 libXScrnSaver
    libXinerama libnotify pango xorgproto librsvg libXrandr
    wayland wayland-protocols
  ];

  outputs = [ "out" "man" ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SYSCONFDIR=$(out)/etc"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  postInstall = ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"

    install -D contrib/_dunst.zshcomp $out/share/zsh/site-functions/_dunst
    install -D contrib/_dunstctl.zshcomp $out/share/zsh/site-functions/_dunstctl
    substituteInPlace $out/share/zsh/site-functions/_dunstctl \
      --replace "jq -M" "${jq}/bin/jq -M"
  '';

  passthru.tests.version = testers.testVersion { package = dunst; };

  meta = with lib; {
    description = "Lightweight and customizable notification daemon";
    homepage = "https://dunst-project.org/";
    license = licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar ];
  };
}
