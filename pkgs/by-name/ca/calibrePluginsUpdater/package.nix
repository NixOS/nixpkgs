{
  writers,
  python3Packages,
}:
writers.writePython3Bin "calibre-plugins-updater" {
  libraries = with python3Packages; [
    aiohttp
    beautifulsoup4
    loguru
  ];
  doCheck = false;
} (builtins.readFile ./update.py)
