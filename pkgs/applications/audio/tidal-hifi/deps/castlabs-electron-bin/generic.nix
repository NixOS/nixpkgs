{ lib
, stdenv
, libXScrnSaver
, makeWrapper
, fetchurl
, wrapGAppsHook
, glib
, gtk3
, unzip
, atomEnv
, libuuid
, at-spi2-atk
, at-spi2-core
, libdrm
, mesa
, libxkbcommon
, libappindicator-gtk3
, libxshmfence
, libglvnd
, wayland
}:

version: hashes:
let
  pname = "castlabs-electron";

  meta = with lib; {
    description = "Cross platform desktop application shell packaged by CastLabs for Widevine support";
    homepage = "https://github.com/castlabs/electron-releases";
    license = licenses.mit;
    # maintainers = with maintainers; [ spikespaz ];
    platforms = builtins.attrNames (removeAttrs hashes [ "headers" ]);
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

  fetcher = vers: tag: hash: fetchurl {
    url = "https://github.com/castlabs/electron-releases/releases/download/v${vers}+wvcus/electron-v${vers}+wvcus-${tag}.zip";
    sha256 = hash;
  };

  headersFetcher = vers: hash: fetchurl {
    url = "https://artifacts.electronjs.org/headers/dist/v${vers}/node-v${vers}-headers.tar.gz";
    sha256 = hash;
  };

  platformTags = {
    x86_64-linux = "linux-x64";
    armv7l-linux = "linux-armv7l";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
    i686-linux = "linux-ia32";
  };

  get = as: platform: as.${platform.system} or (throw "Unsupported system: ${platform.system}");

  common = platform: {
    inherit pname version meta;
    src = fetcher version (get platformTags platform) (get hashes platform);
    passthru.headers = headersFetcher version hashes.headers;
  };

  electronLibPath = lib.makeLibraryPath [
    libuuid
    at-spi2-atk
    at-spi2-core
    libappindicator-gtk3
    wayland
    libdrm
    mesa
    libxkbcommon
    libxshmfence
    libglvnd
  ];

  linux = {
    buildInputs = [ glib gtk3 ];

    nativeBuildInputs = [
      unzip
      makeWrapper
      wrapGAppsHook
    ];

    dontWrapGApps = true; # electron is in lib, we need to wrap it manually

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/lib/electron $out/bin
      unzip -d $out/lib/electron $src
      ln -s $out/lib/electron/electron $out/bin
    '';

    postFixup = ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${electronLibPath}:$out/lib/electron" \
        $out/lib/electron/electron \
        $out/lib/electron/chrome_crashpad_handler

      wrapProgram $out/lib/electron/electron "''${gappsWrapperArgs[@]}"
    '';
  };

  darwin = {
    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      makeWrapper $out/Applications/Electron.app/Contents/MacOS/Electron $out/bin/electron
    '';
  };
in
stdenv.mkDerivation (
  (common stdenv.hostPlatform) //
  (if stdenv.isDarwin then darwin else linux)
)
