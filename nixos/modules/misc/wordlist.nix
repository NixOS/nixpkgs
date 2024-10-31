{ config, lib, pkgs, ... }:
let
  concatAndSort = name: files: pkgs.runCommand name {} ''
    awk 1 ${lib.escapeShellArgs files} | sed '{ /^\s*$/d; s/^\s\+//; s/\s\+$// }' | sort | uniq > $out
  '';
in
{
  options = {
    environment.wordlist = {
      enable = lib.mkEnableOption "environment variables for lists of words";

      lists = lib.mkOption {
        type = lib.types.attrsOf (lib.types.nonEmptyListOf lib.types.path);

        default = {
          WORDLIST = [ "${pkgs.scowl}/share/dict/words.txt" ];
        };

        defaultText = lib.literalExpression ''
          {
            WORDLIST = [ "''${pkgs.scowl}/share/dict/words.txt" ];
          }
        '';

        description = ''
          A set with the key names being the environment variable you'd like to
          set and the values being a list of paths to text documents containing
          lists of words. The various files will be merged, sorted, duplicates
          removed, and extraneous spacing removed.

          If you have a handful of words that you want to add to an already
          existing wordlist, you may find `builtins.toFile` useful for this
          task.
        '';

        example = lib.literalExpression ''
          {
            WORDLIST = [ "''${pkgs.scowl}/share/dict/words.txt" ];
            AUGMENTED_WORDLIST = [
              "''${pkgs.scowl}/share/dict/words.txt"
              "''${pkgs.scowl}/share/dict/words.variants.txt"
              (builtins.toFile "extra-words" '''
                desynchonization
                oobleck''')
            ];
          }
        '';
      };
    };
  };

  config = lib.mkIf config.environment.wordlist.enable {
    environment.variables =
      lib.mapAttrs
        (name: value: "${concatAndSort "wordlist-${name}" value}")
        config.environment.wordlist.lists;
  };
}
