{
  qbittorrent,
  ...
}@args:

qbittorrent.override (
  {
    guiSupport = false;
  }
  // removeAttrs args [ "qbittorrent" ]
)
