let
  testString = "can-use-subgroups";
in import ../make-test-python.nix ({lib, php, ...}: {
  name = "php-${php.version}-httpd-pcre-jit-test";
  meta.maintainers = lib.teams.php.members;

  machine = { lib, pkgs, ... }: {
    time.timeZone = "UTC";
    services.httpd = {
      enable = true;
      adminAddr = "please@dont.contact";
      phpPackage = php;
      enablePHP = true;
      phpOptions = "pcre.jit = true";
      extraConfig = let
        testRoot = pkgs.writeText "index.php"
          ''
            <?php
            preg_match('/(${testString})/', '${testString}', $result);
            var_dump($result);
          '';
      in
        ''
          Alias / ${testRoot}/

          <Directory ${testRoot}>
            Require all granted
          </Directory>
        '';
    };
  };
  testScript = { ... }:
    ''
      machine.wait_for_unit("httpd.service")
      # Ensure php evaluation by matching on the var_dump syntax
      response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/index.php")
      expected = 'string(${toString (builtins.stringLength testString)}) "${testString}"'
      assert expected in response, "Does not appear to be able to use subgroups."
    '';
})
