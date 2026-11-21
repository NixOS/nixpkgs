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

  targetPkgs = pkgs: [
    marvisclient-linux-unwrapped
  ];

  # NOTE: This is a statically compiled tauri app
  multiPkgs =
    pkgs: with pkgs; [
      glib
      glibc
      gtk3
      gst_all_1.gst-plugins-base # Resolves `GStreamer element appsink not found. Please install it.``
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
