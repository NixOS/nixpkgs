# nixpkgs-update: no auto update
{
  _7zz-rar,
  amethyst-mod-manager,
}:
amethyst-mod-manager.override {
  _7zz = _7zz-rar;
}
