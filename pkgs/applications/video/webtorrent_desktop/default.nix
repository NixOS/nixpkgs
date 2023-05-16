<<<<<<< HEAD
{ lib, stdenv, electron_22, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  pname = "webtorrent-desktop";
  version = "0.25-pre";
  src = fetchFromGitHub {
    owner = "webtorrent";
    repo = "webtorrent-desktop";
    rev = "fce078defefd575cb35a5c79d3d9f96affc8a08f";
    sha256 = "sha256-gXFiG36qqR0QHTqhaxgQKDO0UCHkJLnVwUTQB/Nct/c=";
  };
  npmDepsHash = "sha256-pEuvstrZ9oMdJ/iU6XwEQ1BYOyQp/ce6sYBTrMCjGMc=";
  makeCacheWritable = true;
  npmRebuildFlags = [ "--ignore-scripts" ];
  installPhase = ''
    ## Rebuild node_modules for production
    ## after babel compile has finished
    rm -r node_modules
    export NODE_ENV=production
    npm ci --ignore-scripts

    ## delete unused files
    rm -r test

    ## delete config for build time cache
    npm config delete cache

    ## add script wrapper and desktop files; icons
    mkdir -p $out/lib $out/bin $out/share/applications
    cp -r . $out/lib/webtorrent-desktop
    cat > $out/bin/WebTorrent <<EOF
    #! ${stdenv.shell}
    set -eu
    exec ${electron_22}/bin/electron --no-sandbox $out/lib/webtorrent-desktop "\$@"
    EOF
    chmod +x $out/bin/WebTorrent
    cp -r static/linux/share/icons $out/share/
    sed "s#/opt/webtorrent-desktop#$out/bin#" \
      < static/linux/share/applications/webtorrent-desktop.desktop \
      > $out/share/applications/webtorrent-desktop.desktop
  '';
=======
## FIXME: see ../../../servers/code-server/ for a proper yarn packaging
##  - export ELECTRON_SKIP_BINARY_DOWNLOAD=1
##  - jq "del(.scripts.preinstall)" node_modules/shellcheck/package.json | sponge node_modules/shellcheck/package.json
{
  lib, stdenv, buildFHSEnv, runCommand, writeScript, fetchurl, fetchzip
}:
let
  pname = "webtorrent-desktop";
  version = "0.21.0";
in
runCommand "${pname}-${version}" rec {
  inherit (stdenv) shell;
  inherit pname version;
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchzip {
        url = "https://github.com/webtorrent/webtorrent-desktop/releases/download/v${version}/WebTorrent-v${version}-linux.zip";
        sha256 = "13gd8isq2l10kibsc1bsc15dbgpnwa7nw4cwcamycgx6pfz9a852";
      }
    else
      throw "Webtorrent is not currently supported on ${stdenv.hostPlatform.system}";

  fhs = buildFHSEnv rec {
    name = "fhsEnterWebTorrent";
    runScript = "${src}/WebTorrent";
    ## use the trampoline, if you need to shell into the fhsenv
    # runScript = writeScript "trampoline" ''
    #   #!/bin/sh
    #   exec "$@"
    # '';
    targetPkgs = pkgs: with pkgs; with xorg; [
      alsa-lib atk at-spi2-core at-spi2-atk cairo cups dbus expat
      fontconfig freetype gdk-pixbuf glib gtk3 pango libuuid libX11
      libXScrnSaver libXcomposite libXcursor libXdamage libXext
      libXfixes libXi libXrandr libXrender libXtst libxcb nspr nss
      stdenv.cc.cc udev
    ];
    # extraBwrapArgs = [
    #   "--ro-bind /run/user/$(id -u)/pulse /run/user/$(id -u)/pulse"
    # ];
  };

  desktopFile = fetchurl {
    url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/applications/webtorrent-desktop.desktop";
    sha256 = "1v16dqbxqds3cqg3xkzxsa5fyd8ssddvjhy9g3i3lz90n47916ca";
  };
  icon256File = fetchurl {
    url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/icons/hicolor/256x256/apps/webtorrent-desktop.png";
    sha256 = "1dapxvvp7cx52zhyaby4bxm4rll9xc7x3wk8k0il4g3mc7zzn3yk";
  };
  icon48File = fetchurl {
    url = "https://raw.githubusercontent.com/webtorrent/webtorrent-desktop/v${version}/static/linux/share/icons/hicolor/48x48/apps/webtorrent-desktop.png";
    sha256 = "00y96w9shbbrdbf6xcjlahqd08154kkrxmqraik7qshiwcqpw7p4";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Streaming torrent app for Mac, Windows, and Linux";
    homepage = "https://webtorrent.io/desktop";
    license = licenses.mit;
    maintainers = [ maintainers.flokli maintainers.bendlas ];
<<<<<<< HEAD
  };

}
=======
    platforms = [
      "x86_64-linux"
    ];
  };

} ''
  mkdir -p $out/{bin,share/{applications,icons/hicolor/{48x48,256x256}/apps}}

  cp $fhs/bin/fhsEnterWebTorrent $out/bin/WebTorrent

  cp $icon48File $out/share/icons/hicolor/48x48/apps/webtorrent-desktop.png
  cp $icon256File $out/share/icons/hicolor/256x256/apps/webtorrent-desktop.png
  ## Fix the desktop link
  substitute $desktopFile $out/share/applications/webtorrent-desktop.desktop \
    --replace /opt/webtorrent-desktop $out/libexec
''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
