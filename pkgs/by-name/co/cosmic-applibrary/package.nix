{ cosmic-app-library, lib }:

cosmic-app-library.overrideAttrs (oldAttrs: {
  pname = "cosmic-applibrary";
  meta.platforms = lib.platforms.linux;
})
