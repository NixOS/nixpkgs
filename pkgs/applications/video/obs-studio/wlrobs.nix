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
  version = "20200111";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = "8345bf985e390896d89e35e2feae1fa37722f4be";
    sha256 = "0j01wkhwhhla4qx8mwyrq2qj9cfhxksxaq2k8rskmy2qbdkvvdpb";
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
    homepage = https://hg.sr.ht/~scoopta/wlrobs;
    maintainers = with maintainers; [ grahamc ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
