{
  vimUtils,
  taskwarrior2,
}:
vimUtils.buildVimPlugin {
  inherit (taskwarrior2) version pname;
  src = "${taskwarrior2.src}/scripts/vim";
}
