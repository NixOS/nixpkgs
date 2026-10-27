{
  vimUtils,
  taskwarrior3,
}:
vimUtils.buildVimPlugin {
  inherit (taskwarrior3) version pname;
  src = "${taskwarrior3.src}/scripts/vim";

  meta = {
    inherit (taskwarrior3.meta)
      changelog
      description
      homepage
      license
      maintainers
      platforms
      ;
  };
}
