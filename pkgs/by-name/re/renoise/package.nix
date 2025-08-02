{
  lib,
  stdenv,
  writeScript,
  alsa-lib,
  fetchurl,
  libjack2,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
  mpg123,
  pipewire,
  lua-language-server,
  releasePath ? null,
}:

# To use the full release version:
# 1) Sign into https://backstage.renoise.com and download the release version to some stable location.
# 2) Override the releasePath attribute to point to the location of the newly downloaded bundle.
# Note: Renoise creates an individual build for each license which screws somewhat with the
# use of functions like requireFile as the hash will be different for every user.
let
  platforms = {
    x86_64-linux = {
      archSuffix = "x86_64";
      hash = "sha256-BigVJ3TJ0tiDoxe+fX1iSyj6Q1o/8CkAo7fJ8aaftsQ=";
    };
    aarch64-linux = {
      archSuffix = "arm64";
      hash = "sha256-Ee7a8vi9inE4QZoeZtTipXBuZAg2urdicLcm/LUgw5Q=";
    };
  };

in
stdenv.mkDerivation rec {
  pname = "renoise";
  version = "3.5.0";

  src =
    if releasePath != null then
      releasePath
    else
      let
        platform = platforms.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
        urlVersion = lib.replaceStrings [ "." ] [ "_" ] version;
      in
      fetchurl {
        urls = [
          "https://files.renoise.com/demo/Renoise_${urlVersion}_Demo_Linux_${platform.archSuffix}.tar.gz"
          "https://files.renoise.com/demo/archive/Renoise_${urlVersion}_Demo_Linux_${platform.archSuffix}.tar.gz"
        ];
        hash = platform.hash;
      };

  buildInputs = [
    alsa-lib
    libjack2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libXtst
    pipewire
  ];

  installPhase = ''
    cp -r Resources $out

    mkdir -p $out/lib/

    cp renoise $out/renoise

    for path in ${toString buildInputs}; do
      ln -s $path/lib/*.so* $out/lib/
    done

    ln -s ${lib.getLib stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/

    mkdir $out/bin
    ln -s $out/renoise $out/bin/renoise

    # Desktop item
    mkdir -p $out/share/applications
    cp -r Installer/renoise.desktop $out/share/applications/renoise.desktop

    # Desktop item icons
    mkdir -p $out/share/icons/hicolor/{48x48,64x64,128x128}/apps
    cp Installer/renoise-48.png $out/share/icons/hicolor/48x48/apps/renoise.png
    cp Installer/renoise-64.png $out/share/icons/hicolor/64x64/apps/renoise.png
    cp Installer/renoise-128.png $out/share/icons/hicolor/128x128/apps/renoise.png

    # Internal scripting editor
    LuaLS="$out/3rdParty/LuaLS"

    rm -r $LuaLS
    mkdir -p $LuaLS/bin

    pushd $LuaLS/bin
      platform="linux_${platforms.${stdenv.system}.archSuffix}"
      ln -s ${lua-language-server}/bin/lua-language-server lua-language-server-$platform
    popd
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${mpg123}/lib:$out/lib \
      $out/renoise

    for path in $out/AudioPluginServer*; do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath $out/lib \
        $path
    done

    substituteInPlace $out/share/applications/renoise.desktop \
      --replace Exec=renoise Exec=$out/bin/renoise
  '';

  passthru.updateScript = writeScript "update-renoise" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -I nixpkgs=./. -i bash -p curl htmlq common-updater-scripts
    set -euo pipefail

    new_version="$(
      curl 'https://files.renoise.com/demo/' \
        | htmlq a --text \
        | grep -E '^Renoise_([0-9]+_?)+_Demo_Linux_x86_64\.tar\.gz$' \
        | grep -Eo '[0-9]+(_[0-9]+)*' \
        | head -n1 \
        | tr _ .
    )"
    hash_x86_64="$(nix-prefetch-url "https://files.renoise.com/demo/Renoise_$(echo "$new_version" | tr . _)_Demo_Linux_x86_64.tar.gz")"
    hash_arm64="$( nix-prefetch-url "https://files.renoise.com/demo/Renoise_$(echo "$new_version" | tr . _)_Demo_Linux_arm64.tar.gz")"
    sri_x86_64="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash_x86_64")"
    sri_arm64="$( nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash_arm64")"
    update-source-version renoise "$new_version" "$sri_x86_64" --system="x86_64-linux"  --ignore-same-version
    update-source-version renoise "$new_version" "$sri_arm64"  --system="aarch64-linux" --ignore-same-version
  '';

  meta = {
    description = "Modern tracker-based DAW";
    homepage = "https://www.renoise.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ uakci ];
    platforms = lib.attrNames platforms;
    mainProgram = "renoise";
  };
}
