{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
  php ? pkgs.php,
}:

let
  php' = php.buildEnv {
    extensions = { enabled, all }: with all; enabled ++ [ apcu ];
  };
in
{
  fpm = import ./fpm.nix {
    inherit system pkgs;
    php = php';
  };
  httpd = import ./httpd.nix {
    inherit system pkgs;
    php = php';
  };
  pcre = import ./pcre.nix {
    inherit system pkgs;
    php = php';
  };
}
