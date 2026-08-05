{
  vimUtils,
  parinfer-rust,
}:
vimUtils.buildVimPlugin {
  inherit (parinfer-rust) pname version meta;
  src = parinfer-rust;
}
