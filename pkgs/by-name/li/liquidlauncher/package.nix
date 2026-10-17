{
  buildFHSEnv,
  liquidlauncher-unwrapped,
}:

# The launcher runs the JRE, LWJGL natives and LiquidBounce's CEF it downloads at runtime
buildFHSEnv {
  pname = "liquidlauncher";
  inherit (liquidlauncher-unwrapped) version;

  targetPkgs =
    pkgs:
    [ liquidlauncher-unwrapped ]
    ++ (with pkgs; [
      zlib

      # glfw
      libGL
      libx11
      libxcursor
      libxext
      libxi
      libxrandr
      libxxf86vm
      libxkbcommon
      wayland
      libdecor

      # openal
      alsa-lib
      libpulseaudio
      pipewire

      # oshi
      udev

      # narrator
      flite

      # Minecraft tries Vulkan before OpenGL
      vulkan-loader

      # Sodium finds the graphics adapter with lspci
      pciutils

      # AWT, which LiquidBounce renders its fonts with
      fontconfig
      libxrender

      # CEF
      at-spi2-atk
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libgbm
      libxcb
      libxcomposite
      libxdamage
      libxfixes
      libxscrnsaver
      libxshmfence
      libxtst
      nspr
      nss
      pango
    ]);

  runScript = "liquidlauncher";

  profile = ''
    export LIQUIDLAUNCHER_SKIP_UPDATE=1
  '';

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${liquidlauncher-unwrapped}/share/applications $out/share
    ln -s ${liquidlauncher-unwrapped}/share/icons $out/share
  '';

  meta = {
    inherit (liquidlauncher-unwrapped.meta)
      description
      homepage
      changelog
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
