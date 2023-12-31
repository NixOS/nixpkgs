{ lib
, stdenv
, dbus
, fetchFromGitHub
, libGL
, libX11
, libXext
, libXinerama
, libconfig
, libdrm
, libev
, libxcb
, meson
, ninja
, pcre2
, pixman
, pkg-config
, uthash
, xcbutilimage
, xcbutilrenderutil
, xorgproto
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "compfy";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "compfy";
    rev = finalAttrs.version;
    hash = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    libGL
    libX11
    libXext
    libXinerama
    libconfig
    libdrm
    libev
    libxcb
    pcre2
    pixman
    uthash
    xcbutilimage
    xcbutilrenderutil
    xorgproto
  ];

  outputs = [ "out" "man" ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "vsync_drm" true)
  ];

  meta = {
    homepage = "https://github.com/allusive-dev/compfy";
    description = "A compositor for X11, based on Picom";
    longDescription = ''
      Compfy is a Compositor for the X11 platform on Linux. Compfy's main
      purpose is to pretty up your graphical desktop environment by letting
      users have features like transparency, background blurring, rounded
      corners, animations and way more!

      Compfy was made as an alternative to Picom, another popular X11
      compositor. Compfy is based on Picom but provides more features and active
      community support.
    '';
    license = with lib.licenses; [ mit cc0 mpl20 ];
    mainProgram = "compfy";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
