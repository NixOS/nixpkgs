let
  testString = "can-use-subgroups";
in
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    php,
    ...
  }:
  {
    name = "php-${php.version}-httpd-pcre-jit-test";
    meta.maintainers = lib.teams.php.members;

    nodes.machine =
      { lib, pkgs, ... }:
      {
        time.timeZone = "UTC";
        services.httpd = {
          enable = true;
          adminAddr = "please@dont.contact";
          phpPackage = php;
          enablePHP = true;
          phpOptions = "pcre.jit = true";
          extraConfig =
            let
              testRoot = pkgs.writeText "index.php" ''
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
    testScript =
      let
        # PCRE JIT SEAlloc feature does not play well with fork()
        # The feature needs to either be disabled or PHP configured correctly
        # More information in https://bugs.php.net/bug.php?id=78927 and https://bugs.php.net/bug.php?id=78630
        pcreJitSeallocForkIssue = pkgs.writeText "pcre-jit-sealloc-issue.php" ''
          <?php
          preg_match('/nixos/', 'nixos');
          $pid = pcntl_fork();
          pcntl_wait($pid);
        '';
      in
      ''
        machine.wait_for_unit("httpd.service")
        # Ensure php evaluation by matching on the var_dump syntax
        response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/index.php")
        expected = 'string(${toString (builtins.stringLength testString)}) "${testString}"'
        assert expected in response, "Does not appear to be able to use subgroups."
        machine.succeed("${php}/bin/php -f ${pcreJitSeallocForkIssue}")
      '';
  }
)
