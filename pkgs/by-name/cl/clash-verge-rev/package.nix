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
}:
let
  pname = "clash-verge-rev";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-NNP/NDC/Y4oBQftM6Z+pOFMEtdtvcIMYyY3sGwkpmrc=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "2b36be1417cb30ce592951cbadb1503e61c2c784"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-yTttQpWmqhgOx9wPGE01Bjp52QjTXLAfg+7+kPny+yg=";
  };

  service-cargo-hash = "sha256-HET7/Lyc0Ip1f9WMVzUWr0QFuL8YN3dgZdK0adl/rYc=";
  pnpm-hash = "sha256-bhWaDP0gHJC6Mx9QFl4Ltk7y5jozt0eLtsPOWg821Yw=";
  vendor-hash = "sha256-UkiPJNr5leKuffrrh8n2uhCe/QVjIb4S9heZXP7oKqw=";

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
      Guanran928
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
  };
in
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
