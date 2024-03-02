import ./make-test-python.nix (
  { pkgs, ... }:

    let
      user = "gitolite-admin";
      password = "some_password";

      # not used but needed to setup gitolite
      adminPublicKey = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7urFhAA90BTpGuEHeWWTY3W/g9PBxXNxfWhfbrm4Le root@client
      '';
    in
      {
        name = "gitolite-fcgiwrap";

        meta = with pkgs.lib.maintainers; {
          maintainers = [ bbigras ];
        };

        nodes = {

          server =
            { config, ... }:
              {
                networking.firewall.allowedTCPPorts = [ 80 ];

                services.fcgiwrap.enable = true;
                services.gitolite = {
                  enable = true;
                  adminPubkey = adminPublicKey;
                };

                services.nginx = {
                  enable = true;
                  recommendedProxySettings = true;
                  virtualHosts."server".locations."/git".extraConfig = ''
                    # turn off gzip as git objects are already well compressed
                    gzip off;

                    # use file based basic authentication
                    auth_basic "Git Repository Authentication";
                    auth_basic_user_file /etc/gitolite/htpasswd;

                    # common FastCGI parameters are required
                    include ${config.services.nginx.package}/conf/fastcgi_params;

                    # strip the CGI program prefix
                    fastcgi_split_path_info ^(/git)(.*)$;
                    fastcgi_param PATH_INFO $fastcgi_path_info;

                    # pass authenticated user login(mandatory) to Gitolite
                    fastcgi_param REMOTE_USER $remote_user;

                    # pass git repository root directory and hosting user directory
                    # these env variables can be set in a wrapper script
                    fastcgi_param GIT_HTTP_EXPORT_ALL "";
                    fastcgi_param GIT_PROJECT_ROOT /var/lib/gitolite/repositories;
                    fastcgi_param GITOLITE_HTTP_HOME /var/lib/gitolite;
                    fastcgi_param SCRIPT_FILENAME ${pkgs.gitolite}/bin/gitolite-shell;

                    # use Unix domain socket or inet socket
                    fastcgi_pass unix:/run/fcgiwrap.sock;
                  '';
                };

                # WARNING: DON'T DO THIS IN PRODUCTION!
                # This puts unhashed secrets directly into the Nix store for ease of testing.
                environment.etc."gitolite/htpasswd".source = pkgs.runCommand "htpasswd" {} ''
                  ${pkgs.apacheHttpd}/bin/htpasswd -bc "$out" ${user} ${password}
                '';
              };

          client =
            { pkgs, ... }:
              {
                environment.systemPackages = [ pkgs.git ];
              };
        };

        testScript = ''
          start_all()

          server.wait_for_unit("gitolite-init.service")
          server.wait_for_unit("nginx.service")
          server.wait_for_file("/run/fcgiwrap.sock")

          client.wait_for_unit("multi-user.target")
          client.succeed(
              "git clone http://${user}:${password}@server/git/gitolite-admin.git"
          )
        '';
      }
)
