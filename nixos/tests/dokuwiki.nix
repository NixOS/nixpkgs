import ./make-test-python.nix ({ pkgs, ... }:

let
  template-bootstrap3 = pkgs.stdenv.mkDerivation {
    name = "bootstrap3";
    # Download the theme from the dokuwiki site
    src = pkgs.fetchurl {
      url = "https://github.com/giterlizzi/dokuwiki-template-bootstrap3/archive/v2019-05-22.zip";
      sha256 = "4de5ff31d54dd61bbccaf092c9e74c1af3a4c53e07aa59f60457a8f00cfb23a6";
    };
    # We need unzip to build this package
    buildInputs = [ pkgs.unzip ];
    # Installing simply means copying all files to the output directory
    installPhase = "mkdir -p $out; cp -R * $out/";
  };


  # Let's package the icalevents plugin
  plugin-icalevents = pkgs.stdenv.mkDerivation {
    name = "icalevents";
    # Download the plugin from the dokuwiki site
    src = pkgs.fetchurl {
      url = "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip";
      sha256 = "e40ed7dd6bbe7fe3363bbbecb4de481d5e42385b5a0f62f6a6ce6bf3a1f9dfa8";
    };
    # We need unzip to build this package
    buildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    # Installing simply means copying all files to the output directory
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

in {
  name = "dokuwiki";
  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ maintainers."1000101" ];
  };
  machine = { ... }: {
    services.dokuwiki."site1.local" = {
      aclUse = false;
      superUser = "admin";
    };
    services.dokuwiki."site2.local" = {
      usersFile = "/var/lib/dokuwiki/site2.local/users.auth.php";
      superUser = "admin";
      templates = [ template-bootstrap3 ];
      plugins = [ plugin-icalevents ];
    };
    networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
  };

  testScript = ''
    site_names = ["site1.local", "site2.local"]

    start_all()

    machine.wait_for_unit("phpfpm-dokuwiki-site1.local.service")
    machine.wait_for_unit("phpfpm-dokuwiki-site2.local.service")

    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)

    machine.succeed("curl -sSfL http://site1.local/ | grep 'DokuWiki'")
    machine.fail("curl -sSfL 'http://site1.local/doku.php?do=login' | grep 'Login'")

    machine.succeed("curl -sSfL http://site2.local/ | grep 'DokuWiki'")
    machine.succeed("curl -sSfL 'http://site2.local/doku.php?do=login' | grep 'Login'")

    machine.succeed(
        "echo 'admin:$2y$10$ijdBQMzSVV20SrKtCna8gue36vnsbVm2wItAXvdm876sshI4uwy6S:Admin:admin@example.test:user' >> /var/lib/dokuwiki/site2.local/users.auth.php",
        "curl -sSfL -d 'u=admin&p=password' --cookie-jar cjar 'http://site2.local/doku.php?do=login'",
        "curl -sSfL --cookie cjar --cookie-jar cjar 'http://site2.local/doku.php?do=login' | grep 'Logged in as: <bdi>Admin</bdi>'",
    )
  '';
})
