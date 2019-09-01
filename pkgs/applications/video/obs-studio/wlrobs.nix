{ stdenv, fetchhg, obs-studio, wayland }:

stdenv.mkDerivation rec {
  pname = "wlrobs-unstable";
  version = "2019-08-21";
  src = fetchhg {
    url = "https://hg.sr.ht/~scoopta/wlrobs";
    rev = "82e2b93c6f662dfd9d69f7826c0096bef585c3ae";
    sha256 = "1d2mlybkwyr0jw6paamazla2a1cyj60bs10i0lk9jclxnp780fy6";
  };
  buildInputs = [ obs-studio wayland ];
  sourceRoot = "hg-archive/Release";
  installPhase = ''
    PLUGIN_FOLDER="$out/share/obs/obs-plugins/wlrobs/bin/64bit"
    mkdir -p "$PLUGIN_FOLDER"
    install libwlrobs.so "$PLUGIN_FOLDER"
  '';

  meta = with stdenv.lib; {
    description = "OBS capture plugin for wlroots-based compositors like Sway";
    longDescription = ''
      wlrobs is an OBS Studio plugin for capturing the screen under
      wlroots-based Wayland compositors such as Sway.

      There is not a wrapper which can supply obs-studio plugins so you have
      to install the plugin somewhat manually:

      nix-env -iA nixos.wlrobs
      mkdir -p ~/.config/obs-studio/plugins
      ln -s ~/.nix-profile/share/obs/obs-plugins/wlrobs ~/.config/obs-studio/plugins/
    '';
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ jchw ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
