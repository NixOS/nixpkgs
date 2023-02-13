import ./make-test-python.nix ({ pkgs, ... }:

let
  template-bootstrap3 = pkgs.stdenv.mkDerivation rec {
    name = "bootstrap3";
    version = "2022-07-27";
    src = pkgs.fetchFromGitHub {
      owner = "giterlizzi";
      repo = "dokuwiki-template-bootstrap3";
      rev = "v${version}";
      hash = "sha256-B3Yd4lxdwqfCnfmZdp+i/Mzwn/aEuZ0ovagDxuR6lxo=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };


  plugin-icalevents = pkgs.stdenv.mkDerivation rec {
    name = "icalevents";
    version = "2017-06-16";
    src = pkgs.fetchzip {
      stripRoot = false;
      url = "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/${version}/dokuwiki-plugin-icalevents-${version}.zip";
      hash = "sha256-IPs4+qgEfe8AAWevbcCM9PnyI0uoyamtWeg4rEb+9Wc=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  acronymsFile = pkgs.writeText "acronyms.local.conf" ''
    r13y  reproducibility
  '';

  dwWithAcronyms = pkgs.dokuwiki.overrideAttrs (prev: {
    installPhase = prev.installPhase or "" + ''
      ln -sf ${acronymsFile} $out/share/dokuwiki/conf/acronyms.local.conf
    '';
  });

  mkNode = webserver: { ... }: {
    services.dokuwiki = {
      inherit webserver;

      sites = {
        "site1.local" = {
          templates = [ template-bootstrap3 ];
          settings = {
            useacl = false;
            userewrite = true;
            template = "bootstrap3";
          };
        };
        "site2.local" = {
          package = dwWithAcronyms;
          usersFile = "/var/lib/dokuwiki/site2.local/users.auth.php";
          plugins = [ plugin-icalevents ];
          settings = {
            useacl = true;
            superuser = "admin";
            title._file = titleFile;
            plugin.dummy.empty = "This is just for testing purposes";
          };
          acl = [
            { page = "*";
              actor = "@ALL";
              level = "read"; }
            { page = "acl-test";
              actor = "@ALL";
              level = "none"; }
          ];
          pluginsConfig = {
            authad = false;
            authldap = false;
            authmysql = false;
            authpgsql = false;
            tag = false;
            icalevents = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
    networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
  };

  titleFile = pkgs.writeText "dokuwiki-title" "DokuWiki on site2";
in {
  name = "dokuwiki";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [
      _1000101
      onny
      e1mo
    ];
  };

  nodes = {
    dokuwiki_nginx = mkNode "nginx";
    dokuwiki_caddy = mkNode "caddy";
  };

  testScript = ''

    start_all()

    dokuwiki_nginx.wait_for_unit("nginx")
    dokuwiki_caddy.wait_for_unit("caddy")

    site_names = ["site1.local", "site2.local"]

    for machine in (dokuwiki_nginx, dokuwiki_caddy):
      for site_name in site_names:
        machine.wait_for_unit(f"phpfpm-dokuwiki-{site_name}")

        machine.succeed("curl -sSfL http://site1.local/ | grep 'DokuWiki'")
        machine.fail("curl -sSfL 'http://site1.local/doku.php?do=login' | grep 'Login'")

        machine.succeed("curl -sSfL http://site2.local/ | grep 'DokuWiki on site2'")
        machine.succeed("curl -sSfL 'http://site2.local/doku.php?do=login' | grep 'Login'")

        with subtest("ACL Operations"):
          machine.succeed(
            "echo 'admin:$2y$10$ijdBQMzSVV20SrKtCna8gue36vnsbVm2wItAXvdm876sshI4uwy6S:Admin:admin@example.test:user' >> /var/lib/dokuwiki/site2.local/users.auth.php",
            "curl -sSfL -d 'u=admin&p=password' --cookie-jar cjar 'http://site2.local/doku.php?do=login'",
            "curl -sSfL --cookie cjar --cookie-jar cjar 'http://site2.local/doku.php?do=login' | grep 'Logged in as: <bdi>Admin</bdi>'",
          )

          # Ensure the generated ACL is valid
          machine.succeed(
            "echo 'No Hello World! for @ALL here' >> /var/lib/dokuwiki/site2.local/data/pages/acl-test.txt",
            "curl -sSL 'http://site2.local/doku.php?id=acl-test' | grep 'Permission Denied'"
          )

        with subtest("Customizing Dokuwiki"):
          machine.succeed(
            "echo 'r13y is awesome!' >> /var/lib/dokuwiki/site2.local/data/pages/acronyms-test.txt",
            "curl -sSfL 'http://site2.local/doku.php?id=acronyms-test' | grep '<abbr title=\"reproducibility\">r13y</abbr>'",
          )

          # Testing if plugins (a) be correctly loaded and (b) configuration to enable them works
          machine.succeed(
              "echo '~~INFO:syntaxplugins~~' >> /var/lib/dokuwiki/site2.local/data/pages/plugin-list.txt",
              "curl -sSfL 'http://site2.local/doku.php?id=plugin-list' | grep 'plugin:icalevents'",
              "curl -sSfL 'http://site2.local/doku.php?id=plugin-list' | (! grep 'plugin:tag')",
          )

          # Test if theme is applied and working correctly (no weired relative PHP import errors)
          machine.succeed(
            "curl -sSfL 'http://site1.local/doku.php' | grep 'bootstrap3/images/logo.png'",
            "curl -sSfL 'http://site1.local/lib/exe/css.php' | grep 'bootstrap3'",
            "curl -sSfL 'http://site1.local/lib/tpl/bootstrap3/css.php'",
          )


        # Just to ensure both Webserver configurations are consistent in allowing that
        with subtest("Rewriting"):
          machine.succeed(
            "echo 'Hello, NixOS!' >> /var/lib/dokuwiki/site1.local/data/pages/rewrite-test.txt",
            "curl -sSfL http://site1.local/rewrite-test | grep 'Hello, NixOS!'",
          )
  '';
})
