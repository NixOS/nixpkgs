{
  config,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  undmg,

  alsa-lib,
  curl,
  gtk3,
  lame,
  libxml2,
  ffmpeg,
  vlc,
  xdg-utils,
  xdotool,
  which,

  jackSupport ? stdenv.hostPlatform.isLinux,
  jackLibrary,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
}:

let
  url_for_platform =
    version: arch:
    if stdenv.hostPlatform.isDarwin then
      "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${
        builtins.replaceStrings [ "." ] [ "" ] version
      }_universal.dmg"
    else
      "https://www.reaper.fm/files/${lib.versions.major version}.x/reaper${
        builtins.replaceStrings [ "." ] [ "" ] version
      }_linux_${arch}.tar.xz";
in
stdenv.mkDerivation rec {
  pname = "reaper";
  version = "7.41";

  src = fetchurl {
    url = url_for_platform version stdenv.hostPlatform.qemuArch;
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-A4MM+hcpyhw6zE18fSSHBu38A0cYiXzjmM5wqj0Cgzk="
      else
        {
          x86_64-linux = "sha256-9M3WZijLTeKt2Asg3cE1OgS6tm1T4V0Cer9J4GPfTh4=";
          aarch64-linux = "sha256-/Ir1UFUOZOEZPkTG3ykHy6PcOuDf/rbvxOeRt5iJzls=";
        }
        .${stdenv.hostPlatform.system};
  };

  nativeBuildInputs =
    [
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      which
      autoPatchelfHook
      xdg-utils # Required for desktop integration
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin "Reaper.app";

  buildInputs =
    [
      (lib.getLib stdenv.cc.cc) # reaper and libSwell need libstdc++.so.6
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk3
      alsa-lib
    ];

  runtimeDependencies =
    lib.optionals stdenv.hostPlatform.isLinux [
      gtk3 # libSwell needs libgdk-3.so.0
    ]
    ++ lib.optional jackSupport jackLibrary
    ++ lib.optional pulseaudioSupport libpulseaudio;

  dontBuild = true;
  dontStrip = true;

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p "$out/Applications/Reaper.app"
        cp -r * "$out/Applications/Reaper.app/"
        makeWrapper "$out/Applications/Reaper.app/Contents/MacOS/REAPER" "$out/bin/reaper"
        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        HOME="$out/share" XDG_DATA_HOME="$out/share" ./install-reaper.sh \
          --install $out/opt \
          --integrate-user-desktop
        rm $out/opt/REAPER/uninstall-reaper.sh

        # Dynamic loading of plugin dependencies does not adhere to rpath of
        # reaper executable that gets modified with runtimeDependencies.
        # Patching each plugin with DT_NEEDED is cumbersome and requires
        # hardcoding of API versions of each dependency.
        # Setting the rpath of the plugin shared object files does not
        # seem to have an effect for some plugins.
        # We opt for wrapping the executable with LD_LIBRARY_PATH prefix.
        # Note that libcurl and libxml2 are needed for ReaPack to run.
        wrapProgram $out/opt/REAPER/reaper \
          --prefix LD_LIBRARY_PATH : "${
            lib.makeLibraryPath [
              curl
              lame
              libxml2
              ffmpeg
              vlc
              xdotool
              stdenv.cc.cc
            ]
          }"

        mkdir $out/bin
        ln -s $out/opt/REAPER/reaper $out/bin/

        runHook postInstall
      '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Digital audio workstation";
    homepage = "https://www.reaper.fm/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [
      atinba
      ilian
      orivej
      uniquepointer
      viraptor
    ];
  };
}
