{
  lib,
  mihomo,
  callPackage,
  fetchFromGitHub,
  dbip-country-lite,
  stdenv,
  wrapGAppsHook3,
  v2ray-geoip,
  v2ray-domain-list-community,
  libsoup,
  undmg,
  fetchurl,
}:
let
  pname = "clash-verge-rev";
  version = "2.4.2";

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "396150683e01e79740563561ae2fe2db28fb8904"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-D6U22+tJ6vxn8/BTj/PV+4SF5fvGv6KAWtu5+PNJ1SQ=";
  };

  service-cargo-hash = "sha256-54nmhQjtPLMPoRML/3rG1jipT1VC5EDgRXnKDYuLVmM=";
  pnpm-hash = "sha256-neRjVL29xxbQu/XxsQjdAka71oJww40LeDusjsgsY00=";
  vendor-hash = "sha256-XszXDajAdYKEUoyrHZDxxp8ICReMnSdEeKVx7JHiaU4=";

  service = callPackage ./service.nix {
    inherit
      version
      src-service
      service-cargo-hash
      pname
      meta
      ;
  };

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      pnpm-hash
      vendor-hash
      meta
      libsoup
      ;
  };

  src-linux = {
    src = fetchFromGitHub {
      owner = "clash-verge-rev";
      repo = "clash-verge-rev";
      tag = "v${version}";
      hash = "sha256-HBWvk6bX0GjU/yvUejYgTQM8/IP5dYVrf30wNzgWv0s=";
    };
  };
  src-darwin = {
    aarch64-darwin = {
      src = fetchurl {
        url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/Clash.Verge_${version}_aarch64.dmg";
        sha256 = "sha256-V7COnyVLsaNcHHr8iK9X2a3ZapUrFavQx9ycYrEojmY=";
      };
    };
    x86_64-darwin = {
      src = fetchurl {
        url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/Clash.Verge_${version}_x64.dmg";
        sha256 = "sha256-Gk6l7yuja9/6wI1KODHyYP2VG7YoUEz9wVKNry/kPJE";
      };
    };
  };
  source = if stdenv.isDarwin then src-darwin.${stdenv.hostPlatform.system} else src-linux;
  inherit (source) src;

  meta = {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    longDescription = ''
      Clash GUI based on tauri
      Setting NixOS option `programs.clash-verge.enable = true` is recommended.
    '';
    license = lib.licenses.gpl3Only;
    mainProgram = "clash-verge";
    maintainers = with lib.maintainers; [
      hhr2020
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in
if stdenv.isLinux then
  stdenv.mkDerivation {
    inherit
      pname
      src
      version
      meta
      ;

    nativeBuildInputs = [
      wrapGAppsHook3
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share,lib/Clash\ Verge/resources}
      cp -r ${unwrapped}/share/* $out/share
      cp -r ${unwrapped}/bin/clash-verge $out/bin/clash-verge
      # This can't be symbol linked. It will find mihomo in its runtime path
      cp ${service}/bin/clash-verge-service $out/bin/clash-verge-service
      ln -s ${mihomo}/bin/mihomo $out/bin/verge-mihomo
      # people who want to use alpha build show override mihomo themselves. The alpha core entry was removed in clash-verge.
      ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/Clash\ Verge/resources/geoip.dat
      ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/Clash\ Verge/resources/geosite.dat
      ln -s ${dbip-country-lite.mmdb} $out/lib/Clash\ Verge/resources/Country.mmdb

      runHook postInstall
    '';
  }
else
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;
    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";
    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -R "Clash Verge.app" "$out/Applications/Clash Verge.app"
      runHook postInstall
    '';
  }
