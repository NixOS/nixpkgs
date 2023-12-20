{ lib
, fetchzip
}:

fetchzip rec {
  pname = "net-news-wire";
  version = "6.1.4";

  url = "https://github.com/Ranchero-Software/NetNewsWire/releases/download/mac-${version}/NetNewsWire${version}.zip";
  hash = "sha256-GFSWlkC+IoKkfDifH4/TGuFeaJn+qH+xQCTwynFOntE=";

  stripRoot = false;

  postFetch = ''
    rm -rf $out/__MACOSX
    shopt -s extglob
    mkdir $out/Applications
    mv $out/!(Applications) $out/Applications
  '';

  meta = with lib; {
    description = "RSS reader for macOS and iOS";
    longDescription = ''
      It's like podcasts — but for reading.
      NetNewsWire shows you articles from your favorite blogs and news sites and keeps track of what you've read.
    '';
    homepage = "https://github.com/Ranchero-Software/NetNewsWire";
    changelog =
      "https://github.com/Ranchero-Software/NetNewsWire/releases/tag/mac-${version}";
    license = licenses.mit;
    platforms = platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ jakuzure ];
  };
}
