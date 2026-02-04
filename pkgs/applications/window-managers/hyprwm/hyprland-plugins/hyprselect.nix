{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprselect";
  version = "0.53.1";

  src = fetchFromGitHub {
    owner = "jmanc3";
    repo = "hyprselect";
    rev = "f9651b5fd64c730ee164a6fee6a08d0398dcbe0a";
    hash = "sha256-tY8EdfsjlUOuQ9v/POqpyLlkRO5wqEVSE9UeHfXuaGk=";
  };

  inherit (hyprland) nativeBuildInputs;

  meta = with lib; {
    homepage = "https://github.com/jmanc3/hyprselect";
    description = "A plugin that adds a completely useless desktop selection box to Hyprland";
    license = licenses.unlicense;
    platforms = platforms.linux;
  };
})
