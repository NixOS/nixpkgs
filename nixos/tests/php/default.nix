{
  runTest,
  php,
}:

let
  php' = php.buildEnv {
    extensions = { enabled, all }: with all; enabled ++ [ apcu ];
  };
in
{
  fpm = runTest {
    imports = [ ./fpm.nix ];
    _module.args.php = php';
  };
  fpm-modular = runTest {
    imports = [ ./fpm-modular.nix ];
    _module.args.php = php';
  };
  httpd = runTest {
    imports = [ ./httpd.nix ];
    _module.args.php = php';
  };
  pcre = runTest {
    imports = [ ./pcre.nix ];
    _module.args.php = php';
  };
}
