{pkgs, system ? builtins.currentSystem, noDev ? false, php ? pkgs.php, phpPackages ? pkgs.phpPackages}:

let
  composerEnv = import ./composer-env.nix rec {
    inherit (pkgs) stdenv lib writeTextFile fetchurl unzip;
    php =
      pkgs.php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          # extensions per https://www.kimai.org/documentation/installation.html#install-kimai-with-ssh
          # except json as that is on by default https://www.php.net/manual/en/json.installation.php
          # xml already included
          # xsl necessary but not mentioned
          mbstring gd intl pdo tokenizer zip xsl
        ]));
        extraConfig = "memory_limit=256M";
      };
    phpPackages = php.packages;
  };
in
import ./php-packages.nix {
  inherit composerEnv noDev;
  inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn fetchFromGitHub;
}


