{ mkDerivation, lib, fetchurl, meta, version, pname, undmg, makeWrapper }:

let appName = "qBittorrent";
in mkDerivation {
  inherit pname meta version;

  src = fetchurl {
    url = "https://phoenixnap.dl.sourceforge.net/project/qbittorrent/qbittorrent-mac/qbittorrent-${version}/qbittorrent-${version}.dmg";
    sha256 = "sha256-9h+gFAEU0tKrltOjnOKLfylbbBunGZqvPzQogdP9uQM=";
  };

  nativeBuildInputs = [ undmg makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "${appName}.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${pname}" "$out/bin/${pname}"

    runHook postInstall
  '';
}

