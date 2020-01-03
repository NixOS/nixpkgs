# (the following is somewhat lifted from ./linuxbrowser.nix)
# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f . -iA obs-wlrobs
# mkdir -p ~/.config/obs-studio/plugins/wlrobs/bin/64bit
# ln -s ~/.nix-profile/share/obs/obs-plugins/wlrobs/bin/64bit/libwlrobs.so ~/.config/obs-studio/plugins/wlrobs/bin/64bit
{ stdenv, fetchhg, wayland, obs-studio }:
stdenv.mkDerivation {
  pname = "obs-wlrobs";
  version = "20191008";

  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = "82e2b93c6f662dfd9d69f7826c0096bef585c3ae";
    sha256 = "1d2mlybkwyr0jw6paamazla2a1cyj60bs10i0lk9jclxnp780fy6";
  };

  buildInputs = [ wayland obs-studio ];

  preBuild = ''
    cd Release
  '';

  installPhase = ''
    mkdir -p $out/share/obs/obs-plugins/wlrobs/bin/64bit
    cp ./libwlrobs.so $out/share/obs/obs-plugins/wlrobs/bin/64bit/
  '';

  meta = with stdenv.lib; {
    description = "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = https://hg.sr.ht/~scoopta/wlrobs;
    maintainers = with maintainers; [ grahamc ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
