{
  calamares,
  calamares-nixos-extensions,
}:
calamares.override {
  extraWrapperArgs = [
    "--prefix XDG_DATA_DIRS : ${calamares-nixos-extensions}/share"
    "--prefix XDG_CONFIG_DIRS : ${calamares-nixos-extensions}/etc"
    "--add-flag --xdg-config"
  ];
}
