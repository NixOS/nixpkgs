{
  lib,
  buildDotnetModule,
  writeShellScript,
  glibc,
  gtk3,
  libappindicator,
  webkitgtk_4_1,
  e2fsprogs,
  libnotify,
  libgit2,
  openssl,
  xdelta,
  file,
  openjdk,
  patchelf,
  fetchFromGitHub,
  buildFHSEnv,
  glib-networking,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  dotnetCorePackages,
}:
let
  am2r-run = buildFHSEnv {
    name = "am2r-run";

    multiArch = true;

    multiPkgs =
      pkgs: with pkgs; [
        (lib.getLib stdenv.cc.cc)
        libx11
        libxext
        libxrandr
        libxxf86vm
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
  version = "2.3.0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "AM2R-Community-Developers";
    repo = "AM2RLauncher";
    rev = "f9bd0a3e0b661648b0ce1b0531dc174d9ebcf7d9";
    hash = "sha256-bXUBw8XN3iR3UL1vvTsBqnnnJGxMIxFCg1tVVyAxRPw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  projectFile = "AM2RLauncher/AM2RLauncher.Gtk/AM2RLauncher.Gtk.csproj";

  nugetDeps = ./deps.json;
  executables = "AM2RLauncher.Gtk";

  runtimeDeps = [
    glibc
    gtk3
    libappindicator
    webkitgtk_4_1
    e2fsprogs
    libnotify
    libgit2
    openssl
  ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    gtk3
    gsettings-desktop-schemas
    glib-networking
  ];

  patches = [
    ./am2r-run-binary.patch
  ];

  dotnetFlags = [
    ''-p:DefineConstants="NOAPPIMAGE;NOAUTOUPDATE;PATCHOPENSSL"''
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.escapeShellArg (
      lib.makeBinPath [
        am2r-run
        xdelta
        file
        openjdk
        patchelf
      ]
    ))
  ];

  postFixup = ''
    mkdir -p $out/share/icons
    install -Dm644 $src/AM2RLauncher/distribution/linux/AM2RLauncher.png $out/share/icons/AM2RLauncher.png
    install -Dm644 $src/AM2RLauncher/distribution/linux/AM2RLauncher.desktop $out/share/applications/AM2RLauncher.desktop

    # renames binary for desktop file
    mv $out/bin/AM2RLauncher.Gtk $out/bin/AM2RLauncher
  '';

  meta = {
    homepage = "https://github.com/AM2R-Community-Developers/AM2RLauncher";
    description = "Front-end for dealing with AM2R updates and mods";
    longDescription = ''
      A front-end application that simplifies installing the latest
      AM2R-Community-Updates, creating APKs for Android use, as well as Mods for
      AM2R.
    '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nsnelson ];
    mainProgram = "AM2RLauncher";
    platforms = lib.platforms.linux;
  };
}
