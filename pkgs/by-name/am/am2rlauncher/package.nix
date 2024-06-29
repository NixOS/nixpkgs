{ lib
, buildDotnetModule
, writeShellScript
, glibc
, gtk3
, libappindicator
, webkitgtk
, e2fsprogs
, libnotify
, libgit2
, openssl
, xdelta
, file
, busybox
, openjdk
, patchelf
, fetchFromGitHub
, buildFHSEnv
, glib-networking
, wrapGAppsHook3
, gsettings-desktop-schemas
}:
let
  am2r-run = buildFHSEnv {
    name = "am2r-run";

    multiArch = true;

    multiPkgs = pkgs: with pkgs; [
        stdenv.cc.cc.lib
        xorg.libX11
        xorg.libXext
        xorg.libXrandr
        xorg.libXxf86vm
        curl
        libGLU
        libglvnd
        openal
        zlib
      ];

    runScript = writeShellScript "am2r-run" ''
      exec -- "$1" "$@"
    '';
  };
in
buildDotnetModule {
  pname = "am2rlauncher";
  version = "2.3.0-unstable-2023-11-08";

  src = fetchFromGitHub {
    owner = "AM2R-Community-Developers";
    repo = "AM2RLauncher";
    rev = "5d8b7d9b3de68e6215c10b9fd223b7f1d5e40dea";
    sha256 = "sha256-/nHqo8jh3sOUngbpqdfiQjUWO/8Uzpc5jtW7Ep4q6Wg=";
  };

  projectFile = "AM2RLauncher/AM2RLauncher.Gtk/AM2RLauncher.Gtk.csproj";

  nugetDeps = ./deps.nix;
  executables = "AM2RLauncher.Gtk";

  runtimeDeps = [
    glibc
    gtk3
    libappindicator
    webkitgtk
    e2fsprogs
    libnotify
    libgit2
    openssl
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [ gtk3 gsettings-desktop-schemas glib-networking ];

  patches = [ ./am2r-run-binary.patch ];

  dotnetFlags = [ ''-p:DefineConstants="NOAPPIMAGE;NOAUTOUPDATE;PATCHOPENSSL"'' ];

  postFixup = ''
    wrapProgram $out/bin/AM2RLauncher.Gtk \
      --prefix PATH : ${lib.makeBinPath [ am2r-run xdelta file openjdk patchelf ]} \

    mkdir -p $out/share/icons
    install -Dm644 $src/AM2RLauncher/distribution/linux/AM2RLauncher.png $out/share/icons/AM2RLauncher.png
    install -Dm644 $src/AM2RLauncher/distribution/linux/AM2RLauncher.desktop $out/share/applications/AM2RLauncher.desktop

    # renames binary for desktop file
    mv $out/bin/AM2RLauncher.Gtk $out/bin/AM2RLauncher
  '';

  meta = with lib; {
    homepage = "https://github.com/AM2R-Community-Developers/AM2RLauncher";
    description = "Front-end for dealing with AM2R updates and mods";
    longDescription = ''
      A front-end application that simplifies installing the latest
      AM2R-Community-Updates, creating APKs for Android use, as well as Mods for
      AM2R.
    '';
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nsnelson ];
    mainProgram = "AM2RLauncher";
    platforms = platforms.linux;
  };
}
