{
  lib,
  discourse,
}:

discourse.override {
  plugins = lib.filter (p: p ? pluginName) (builtins.attrValues discourse.plugins);
}
