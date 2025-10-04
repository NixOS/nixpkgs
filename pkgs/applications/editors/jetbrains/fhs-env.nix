{ buildFHSEnv }:
{
  product,
  pname,
  version,
  executableName,
  extraTargetPkgs ? pkgs: [ ],
  extraMultiPkgs ? pkgs: [ ],
  meta,
}:
buildFHSEnv {
  inherit pname version meta;

  targetPkgs =
    pkgs:
    (with pkgs; [
      # Generic Libraries
      # ld-linux-x86-64-linux.so.2 and others
      glibc

      # Libraries for GUI Applications.
      # Note(sewer56): These are currently derived from the minimal set required to run AvaloniaUI
      # on .NET (Rider). Although unlikely, there is still a possibility of there being more in the
      # future for other UI frameworks.
      udev
      alsa-lib
      fontconfig
      glew

      # X11 libraries for Avalonia
      xorg.libX11
      xorg.libICE
      xorg.libSM
      xorg.libXi
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr

      # unpatched dotnet binaries
      # https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#dependencies
      curl
      icu
      libunwind
      libuuid
      lttng-ust
      openssl
      zlib

      # mono
      krb5

      # Needed for plugins which ship standalone browser binaries such as
      # anything based on Puppeteer https://pptr.dev .
      # Related: https://github.com/NixOS/nixpkgs/pull/430254
      glib
      nspr
      nss
      dbus
      at-spi2-atk
      cups
      expat
      libxkbcommon
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libxcb
      xorg.libXfixes
      cairo
      pango
      libgbm
      libudev0-shim
    ])
    ++ (extraTargetPkgs pkgs);

  multiPkgs =
    pkgs:
    (with pkgs; [
      # Avalonia & Graphical Applications
      udev
      alsa-lib
    ])
    ++ (extraMultiPkgs pkgs);

  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
  ];

  runScript = "${product}/bin/${executableName}";

  extraInstallCommands = ''
    # Symlink shared assets including icons and desktop entries
    ln -s "${product}/share" "$out/"
  '';

  passthru = {
    # Provide access to the unwrapped package
    unwrapped = product;
    inherit executableName;
    inherit (product) pname version;
  };
}
