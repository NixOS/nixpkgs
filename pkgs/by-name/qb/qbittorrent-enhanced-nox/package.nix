{
  qbittorrent-enhanced,
  ...
}@args:

qbittorrent-enhanced.override (
  {
    guiSupport = false;
  }
  // removeAttrs args [ "qbittorrent-enhanced" ]
)
