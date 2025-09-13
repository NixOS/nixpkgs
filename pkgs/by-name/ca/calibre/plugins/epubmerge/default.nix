{ mkCalibrePlugin, lib }:

mkCalibrePlugin rec {
  pname = "epubmerge";
  version = "3.2.0";
  url = "https://github.com/JimmXinu/EpubMerge/releases/download/v${version}/EpubMerge.zip";
  sha256 = "sha256-GH6JE7bnnytdOocNtSnh5ENV5cEr7vM6BRyJC8uTijU=";

  meta = {
    description = "A Calibre plugin to merge multiple EPUB files into a single volume";
    homepage = "https://github.com/JimmXinu/EpubMerge";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ xavwe ];
  };
}
