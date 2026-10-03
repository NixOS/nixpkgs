{
  lib,
  pkgs,
  buildFHSEnv,
  marvisclient-linux-unwrapped,
}:
buildFHSEnv {
  pname = "marvisclient-linux";
  inherit (marvisclient-linux-unwrapped) version;

  runScript = "marvisclient-linux";

  targetPkgs =
    pkgs: with pkgs; [
      marvisclient-linux-unwrapped
    ];

  multiPkgs =
    pkgs: with pkgs; [
      glib
      glibc
      gtk3
      gst_all_1.gst-plugins-base
      cairo
      gdk-pixbuf
      libsoup_3
      webkitgtk_4_1
      libcap
      libpthread-stubs
      libselinux
      glib-networking
      xdg-utils
      desktop-file-utils
      shared-mime-info
      openssl
    ];

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${marvisclient-linux-unwrapped}/share/applications $out/share
    ln -sf ${marvisclient-linux-unwrapped}/share/icons $out/share
  '';

  meta = {
    inherit (marvisclient-linux-unwrapped.meta)
      homepage
      description
      platforms
      license
      maintainers
      broken
      ;
    mainProgram = "marvisclient-linux";
  };
}
