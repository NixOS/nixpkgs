# Modeled on Saber (pkgs/by-name/sa/saber/package.nix), the canonical
# packaged Flutter desktop app in nixpkgs. Every mechanic verified against
# master sources:
#   * postBuild IS a real hook: build-flutter-application.nix's linux
#     buildPhase ends in `runHook postBuild` (after `flutter build linux`).
#   * the linux installPhase moves the bundle to $out/app/$pname and
#     auto-symlinks every top-level executable into $out/bin — do NOT
#     create those symlinks manually (they collide).
#   * dartFixupHook wraps $out/bin/* with LD_LIBRARY_PATH from
#     `runtimeDependencies` plus `extraWrapProgramArgs` — helper tools the
#     daemon shells out to therefore belong on PATH via extraWrapProgramArgs,
#     NOT in runtimeDependencies (which lib.getLib-maps to lib dirs).
{
  lib,
  flutter344,
  fetchFromGitHub,
  autoPatchelfHook,
  gtk3,
  glib, # gio/gio.h for src/notify.c (headers via pkg-config)
  at-spi2-core,
  xdotool,
  xprop,
  xprintidle,
  python3,
}:

let
  version = "1.1.2";

  pyWithPyatspi = python3.withPackages (ps: [ ps.pyatspi ]); # verified attr: python3Packages.pyatspi

  src = fetchFromGitHub {
    owner = "adityakrishnan005-a11y";
    repo = "ScreenGuard";
    tag = "v${version}";
    # Hash of the *source tree* at the tag (NOT the release bundle tarball).
    # Refresh with:
    #   curl -sL https://github.com/adityakrishnan005-a11y/ScreenGuard/archive/refs/tags/v1.1.2.tar.gz -o t.tgz
    #   python3 tools/github-nar-hash.py t.tgz
    # (calibrated byte-for-byte against Nix's fetcher; see tool docstring)
    hash = "sha256-EwZX80LSUa1v84dAyjFdJpLEXqvi/m49tPbL2xQY/9Y=";
  };
in
# flutter344 — same pin Saber ships today. Newer Flutters exist in the trunk
# (versions/: 3_29..3_47) but Saber deliberately stays on 344 for the linux
# build; revisit at PR time only if ofBorg forces it.
flutter344.buildFlutterApplication {
  pname = "screenguard";
  inherit version src;

  gitHashes = lib.importJSON ./git-hashes.json;
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gtk3
    glib
    at-spi2-core
  ];

  # The daemon/helpers exec xdotool, xprop, xprintidle and python (pyatspi)
  # by name — make sure the wrapped $out/bin entries can find them.
  extraWrapProgramArgs =
    "--prefix PATH : ${lib.makeBinPath [ xdotool xprop xprintidle pyWithPyatspi ]}";

  # Runs after `flutter build linux`, before the bundle is moved to
  # $out/app/screenguard — perfect place to merge the C helpers and the
  # standalone daemon into the bundle (the hook then symlinks them into
  # $out/bin for us).
  #
  # The daemon is NOT part of the flutter build (see tools/build-tarball.sh:
  # `dart compile exe bin/daemon.dart`); it only needs a plain AOT dart exe.
  # dontDartBuild skips the stock compile hook, but dartConfigHook still
  # assembled .dart_tool/package_config.json from pub2nix's linked store
  # sources, so package:screenguard/* resolve offline. `dart` on PATH is the
  # flutter SDK's dart (buildAppWith overrides buildDartApplication's dart).
  postBuild = ''
    dart compile exe bin/daemon.dart -o build/linux/x64/release/bundle/screenguard-daemon

    cc src/watchdog.c -O2 -o build/linux/x64/release/bundle/screenguard-watchdog
    cc src/killer.c  -O2 -o build/linux/x64/release/bundle/screenguard-killer
    cc src/notify.c  -O2 $(pkg-config --cflags --libs gio-2.0) \
        -o build/linux/x64/release/bundle/screenguard-notify
  '';

  postInstall = ''
    install -Dm0644 linux/screenguard.desktop $out/share/applications/screenguard.desktop
    install -Dm0644 packaging/org.screenguard.ScreenGuard.appdata.xml -t $out/share/metainfo
    install -Dm0644 assets/icons/scalable/screenguard.svg $out/share/icons/hicolor/scalable/apps/screenguard.svg
    install -Dm0644 assets/icons/256x256/screenguard.png $out/share/icons/hicolor/256x256/apps/screenguard.png

    # systemd user service + preset (systemd.packages picks these from
    # $out/lib/systemd). ExecStart must point at our OWN wrapper, /usr/bin
    # does not exist on NixOS.
    install -Dm0644 linux/screenguard.service $out/lib/systemd/user/screenguard.service
    install -Dm0644 linux/50-screenguard.preset $out/lib/systemd/user-preset/50-screenguard.preset
    substituteInPlace $out/lib/systemd/user/screenguard.service \
      --replace-raw "ExecStart=/usr/bin/screenguard-daemon" "ExecStart=$out/bin/screenguard-daemon"

    # Helper script imported by the daemon (invoked with python3, which the
    # wrappers put on PATH with pyatspi available)
    install -Dm0644 bin/active_window_helper.py $out/app/screenguard/active_window_helper.py
    install -Dm0644 tools/enable_fedora_a11y.sh $out/share/screenguard/enable_fedora_a11y.sh
    install -Dm0644 tools/migrate.sh $out/share/screenguard/migrate.sh
  '';

  meta = {
    description = "Digital Wellbeing for Linux — screen time tracking, daily app limits & focus mode";
    homepage = "https://github.com/adityakrishnan005-a11y/ScreenGuard";
    mainProgram = "screenguard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ adityakrishnan005-a11y ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
