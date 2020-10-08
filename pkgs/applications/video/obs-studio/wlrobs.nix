# (the following is somewhat lifted from ./linuxbrowser.nix)
# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f . -iA obs-wlrobs
# mkdir -p ~/.config/obs-studio/plugins/wlrobs/bin/64bit
# ln -s ~/.nix-profile/share/obs/obs-plugins/wlrobs/bin/64bit/libwlrobs.so ~/.config/obs-studio/plugins/wlrobs/bin/64bit
{ stdenv, fetchhg, wayland, obs-studio
, meson, ninja, pkgconfig, libX11
, dmabufSupport ? false, libdrm ? null, libGL ? null}:

assert dmabufSupport -> libdrm != null && libGL != null;

stdenv.mkDerivation {
  pname = "obs-wlrobs";
  version = "20200622";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = "1d3acaaf64049da3da9721aa8b9b47582fe0081b";
    sha256 = "0qrcf8024r4ynfjw0zx8vn59ygx9q5rb196s6nyxmy3gkv2lfxlq";
  };

  buildInputs = [ libX11 libGL libdrm meson ninja pkgconfig wayland obs-studio ];

  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/wlrobs/bin/64bit
    cp ./libwlrobs.so $out/share/obs/obs-plugins/wlrobs/bin/64bit/
  '';

  mesonFlags = [
    "-Duse_dmabuf=${if dmabufSupport then "true" else "false"}"
  ];

  meta = with stdenv.lib; {
    description = "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
