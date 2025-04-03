{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "net-news-wire";
  version = "6.1.4";

  src = fetchurl {
    url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
    hash = "sha256-dNdbniXGre8G2/Ac0GB3GHJ2k1dEiHmAlTX3dJOEC7s=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R NetNewsWire.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    description = "RSS reader for macOS and iOS";
    longDescription = ''
      It's like podcasts — but for reading.
      NetNewsWire shows you articles from your favorite blogs and news sites and keeps track of what you've read.
    '';
    homepage = "https://github.com/Ranchero-Software/NetNewsWire";
    changelog = "https://github.com/Ranchero-Software/NetNewsWire/releases/tag/mac-${version}";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ jakuzure ];
  };
}
