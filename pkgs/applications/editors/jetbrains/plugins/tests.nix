{ jetbrains, writeText }:

{
  # Check to see if the process for adding plugins is breaking anything, instead of the plugins themselves
  default =
    let
      modify-ide = ide: jetbrains.plugins.addPlugins ide [ ];
      ides = with jetbrains; map modify-ide [
        clion
        datagrip
        dataspell
        goland
        idea-community
        idea-ultimate
        mps
        phpstorm
        pycharm-community
        pycharm-professional
        rider
        ruby-mine
        rust-rover
        webstorm
      ];
      paths = builtins.concatStringsSep " " ides;
    in
    writeText "jb-ides" paths;

    clion-with-vim = jetbrains.plugins.addPlugins jetbrains.clion [ "ideavim" ];
}
