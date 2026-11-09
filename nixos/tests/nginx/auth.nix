{
  mkPackage ? builtins.getAttr "nginx",
  name ? "default",
  ...
}:
{
  name = "nginx-auth-${name}";

  containers = {
    webserver =
      { pkgs, lib, ... }:
      {
        services.nginx =
          let
            root = pkgs.runCommand "testdir" { } ''
              mkdir "$out"
              echo hello world > "$out/index.html"
            '';
          in
          {
            enable = true;
            package = mkPackage pkgs;

            virtualHosts.lockedroot = {
              inherit root;
              basicAuth.alice = "pwofa";
            };

            virtualHosts.lockedsubdir = {
              inherit root;
              locations."/sublocation/" = {
                alias = "${root}/";
                basicAuth.bob = "pwofb";
              };
            };
            #check if bcrypt and sha libraries work
            virtualHosts.shaandbcrypt = {
              basicAuthFile = pkgs.writeText "auth" ''
                sha512_user:$6$oxg72Ga3kLzkGBi/$d7ZVYYkDwdxqxcLvXAkrFSd4LodKlmgMSLfsPQCrJys2SnC0B6HHNcRs5b.Ik.qXBvlOXfjv6NK7fpacelKdX0
                bcrypt_user:$2y$05$HPPqMu4asDMqKrtxpzVrye.lOsBMbIQiesOmPwyjXplqfUacakexe

              '';
            };
          };
      };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.fail("curl --fail --resolve lockedroot:80:127.0.0.1 http://lockedroot")
    webserver.succeed(
        "curl --fail --resolve lockedroot:80:127.0.0.1 --user alice:pwofa http://lockedroot"
    )

    webserver.succeed("curl --fail --resolve lockedsubdir:80:127.0.0.1 http://lockedsubdir")
    webserver.fail(
        "curl --fail --resolve lockedsubdir:80:127.0.0.1 http://lockedsubdir/sublocation/index.html"
    )
    webserver.succeed(
        "curl --fail --resolve lockedsubdir:80:127.0.0.1 --user bob:pwofb http://lockedsubdir/sublocation/index.html"
    )

    webserver.succeed(
        "curl --fail --resolve shaandbcrypt:80:127.0.0.1 --user sha512_user:sha512_password http://shaandbcrypt"
    )
    webserver.succeed(
        "curl --fail --resolve shaandbcrypt:80:127.0.0.1 --user bcrypt_user:bcrypt_password http://shaandbcrypt"
    )
    webserver.fail(
        "curl --fail --resolve shaandbcrypt:80:127.0.0.1 --user sha512_user:sha512_wrong_password http://shaandbcrypt"
    )
    webserver.fail(
        "curl --fail --resolve shaandbcrypt:80:127.0.0.1 --user bcrypt_user:bcrypt__wrong_password http://shaandbcrypt"
    )
  '';
}
