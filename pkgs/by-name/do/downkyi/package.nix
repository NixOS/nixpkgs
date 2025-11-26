{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  icu,
  # For update script
  writeShellScript,
  common-updater-scripts,
  curl,
  gnused,
  jq,
}:

let
  pname = "downkyi";
  version = "1.0.23";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://github.com/yaobiao131/downkyicore/releases/download/v${version}/DownKyi-${version}_linux_self-contained.x86_64.AppImage";
        hash = "sha256-bwT8h+7V4k9Nw+B4r46S7CIWUl49bG8njRoOqnitcE0=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/yaobiao131/downkyicore/releases/download/v${version}/DownKyi-${version}_linux_self-contained.aarch64.AppImage";
        hash = "sha256-aIsgO5Kpr4Luupfxyq6q1tui6NkTJ3MY0flVhiqAubg=";
      };
    };
    updateScipt = writeShellScript "update-downkyi" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          curl
          gnused
          jq
        ]
      }"
      NEW_VERSION=$(curl -s https://api.github.com/repos/yaobiao131/downkyicore/releases/latest | jq .tag_name --raw-output | sed -e 's/v//')

      if [[ "${version}" = "$NEW_VERSION" ]]; then
        echo "The new version same as the old version."
        exit 0
      fi

      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "downkyi" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  src =
    passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");

  meta = {
    description = "Bilibili video download tool, supports batch downloads, 8K, HDR, Dolby Vision, and provides a toolbox (audio and video extraction, watermark removal, etc.).";
    homepage = "https://github.com/yaobiao131/downkyicore";
    changelog = "https://github.com/yaobiao131/downkyicore/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = builtins.attrNames passthru.sources;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "downkyi";
  };
in

appimageTools.wrapType2 {
  inherit
    pname
    version
    passthru
    src
    meta
    ;

  extraPkgs = pkgs: [ icu ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/cn.bzdrs.downkyi.desktop $out/share/applications/downkyi.desktop
      substituteInPlace $out/share/applications/downkyi.desktop \
        --replace-fail "env LANG=zn_CN.UTF-8 " "" \
        --replace-fail "Exec=/usr/bin/DownKyi" "Exec=downkyi" \
        --replace-fail "Icon=cn.bzdrs.downkyi" "Icon=downkyi"
      for i in 16 32 64 128 256 512 1024; do
        size=''${i}x''${i}
        install -Dm444 ${appimageContents}/usr/share/icons/hicolor/$size/apps/cn.bzdrs.downkyi.png $out/share/icons/hicolor/$size/apps/downkyi.png
      done
    '';
}
