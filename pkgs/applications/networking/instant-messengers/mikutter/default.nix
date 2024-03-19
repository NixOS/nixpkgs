{ lib
, stdenv
, fetchurl
, bundlerEnv
, alsa-utils
, atk
, copyDesktopItems
, gobject-introspection
, gtk2
, ruby
, libicns
, libnotify
, makeDesktopItem
, which
, wrapGAppsHook
, writeText
}:

let
  # NOTE: $out may have different values depending on context
  mikutterPaths = rec {
    optPrefixDir = "$out/opt/mikutter";
    appPrefixDir = "$out/Applications/mikutter.app/Contents";
    appBinDir = "${appPrefixDir}/MacOS";
    appResourceDir = "${appPrefixDir}/Resources";
    iconPath = "${optPrefixDir}/core/skin/data/icon.png";
  };

  gems = bundlerEnv {
    name = "mikutter-gems"; # leave the version out to enable package reuse
    gemdir = ./deps;
    groups = [ "default" "plugin" ];
    inherit ruby;

    # Avoid the following error:
    # > `<module:Moneta>': uninitialized constant Moneta::Builder (NameError)
    #
    # Related:
    # https://github.com/NixOS/nixpkgs/pull/76510
    # https://github.com/NixOS/nixpkgs/pull/76765
    # https://github.com/NixOS/nixpkgs/issues/83442
    # https://github.com/NixOS/nixpkgs/issues/106545
    copyGemFiles = true;
  };

  mkDesktopItem = { description }:
    makeDesktopItem {
      name = "mikutter";
      desktopName = "mikutter";
      exec = "mikutter";
      icon = "mikutter";
      categories = [ "Network" ];
      comment = description;
      keywords = [ "Mastodon" ];
    };

  mkInfoPlist = { version }:
    writeText "Info.plist" (lib.generators.toPlist { } {
      CFBundleName = "mikutter";
      CFBundleDisplayName = "mikutter";
      CFBundleExecutable = "mikutter";
      CFBundleIconFile = "mikutter";
      CFBundleIdentifier = "net.hachune.mikutter";
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundlePackageType = "APPL";
      CFBundleVersion = version;
      CFBundleShortVersionString = version;
    });

  inherit (gems) wrappedRuby;
in
with mikutterPaths; stdenv.mkDerivation rec {
  pname = "mikutter";
  version = "4.1.4";

  src = fetchurl {
    url = "https://mikutter.hachune.net/bin/mikutter-${version}.tar.gz";
    sha256 = "05253nz4i1lmnq6czj48qdab2ny4vx2mznj6nsn2l1m2z6zqkwk3";
  };

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook gobject-introspection ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];
  buildInputs = [
    atk
    gtk2
    libnotify
    which # some plugins use it at runtime
    wrappedRuby
  ] ++ lib.optionals stdenv.isLinux [ alsa-utils ];

  scriptPath = lib.makeBinPath (
    [ wrappedRuby libnotify which ]
    ++ lib.optionals stdenv.isLinux [ alsa-utils ]
  );

  postUnpack = ''
    rm -rf vendor
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin ${optPrefixDir}

    install -Dm644 README $out/share/doc/mikutter/README
    install -Dm644 LICENSE $out/share/doc/mikutter/LICENSE
    rm -r README LICENSE deployment

    cp -r . ${optPrefixDir}

    gappsWrapperArgsHook # FIXME: currently runs at preFixup
    wrapGApp ${optPrefixDir}/mikutter.rb \
      --prefix PATH : "${scriptPath}" \
      --set DISABLE_BUNDLER_SETUP 1
    mv ${optPrefixDir}/mikutter.rb $out/bin/mikutter

    install -Dm644 ${iconPath} $out/share/icons/hicolor/256x256/apps/mikutter.png

    runHook postInstall
  '';

  postInstall =
    let
      infoPlist = mkInfoPlist { inherit version; };
    in
    lib.optionalString stdenv.isDarwin ''
      mkdir -p ${appBinDir} ${appResourceDir}
      install -Dm644 ${infoPlist} ${appPrefixDir}/Info.plist
      ln -s $out/bin/mikutter ${appBinDir}/mikutter
      png2icns ${appResourceDir}/mikutter.icns ${iconPath}
    '';

  installCheckPhase = ''
    runHook preInstallCheck

    testDir="$(mktemp -d)"
    install -Dm644 ${./test_plugin.rb} "$testDir/plugin/test_plugin/test_plugin.rb"

    $out/bin/mikutter --confroot="$testDir" --plugin=test_plugin --debug

    runHook postInstallCheck
  '';

  desktopItems = [
    (mkDesktopItem { inherit (meta) description; })
  ];

  doInstallCheck = true;
  dontWrapGApps = true; # the target is placed outside of bin/

  passthru.updateScript = [ ./update.sh version (toString ./.) ];

  meta = with lib; {
    description = "An extensible Mastodon client";
    homepage = "https://mikutter.hachune.net";
    platforms = ruby.meta.platforms;
    license = licenses.mit;
  };
}
