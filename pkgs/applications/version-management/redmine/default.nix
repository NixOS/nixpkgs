{ stdenv, lib, fetchurl, bundlerEnv, ruby
, callPackage, runCommand, buildEnv
, git, openssl, glibc
}:
let
  withPlugins = plugins:
    let
      version = "3.4.6";
      propagatedPlugins =
        with stdenv.lib;
          filter (x: x ? isRedminePlugin)
            (closePropagation plugins);
      rubyEnv = bundlerEnv rec {
        name  = "redmine-env-${version}";
        pname = "redmine-env-${version}";
        inherit ruby;
        gemdir =
          runCommand "gemfile-and-lockfile" {
            buildInputs = [
              ruby.devEnv
              git
              openssl
              glibc # NOTE: for getent
            ];
          } (''
              mkdir -p $out
              cp ${./Gemfile} $out/Gemfile
              mkdir $out/plugins
            '' + lib.concatMapStringsSep "\n" (plugin: ''
              mkdir $out/plugins/${plugin.pname}
              for gemfile in Gemfile PluginGemFile; do
                test ! -e ${plugin}/${plugin.pname}/$gemfile ||
                cp ${plugin}/${plugin.pname}/$gemfile $out/plugins/${plugin.pname}
              done
            '') propagatedPlugins + ''
              # NOTE: workaround from https://github.com/NixOS/nixpkgs/issues/8534
              test ! -e /etc/ssl/certs/ca-certificates.crt ||
              export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
              # NOTE: cache downloads in running user's home
              export HOME="$(getent passwd "$(id -u)" | cut -f6 -d:)"
              cd $out
              bundle config without development test
              bundle lock # NOTE: generate Gemfile.lock
              bundix      # NOTE: generate gemset.nix
            ''
          );
        gemset =
          import "${gemdir}/gemset.nix" //
          # NOTE: gemset entry using source.type="path"
          #       to copy the above gemdir in rubyEnv.basicEnv.confFiles
          { "redmine-env-${version}" = {
              gemName = "redmine-env-${version}";
              version = version;
              source.type = "path";
              path = ./.;
              dependencies = [];
            };
          };
      };
      pluginEnv = buildEnv {
        name = "redmine-plugins-${version}";
        paths = propagatedPlugins;
      };
    in
    stdenv.mkDerivation rec {
      name = "redmine-${version}";

      src = fetchurl {
        url = "https://www.redmine.org/releases/${name}.tar.gz";
        sha256 = "15akq6pn42w7cf7dg45xmvw06fixck1qznp7s8ix7nyxlmcyvcg3";
      };

      buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler ];

      passthru = {
        plugins = callPackage ( import ./plugins.nix ) { };
        inherit withPlugins;
        inherit rubyEnv;
      };

      installPhase = ''
        mkdir -p $out/share
        cp -r . $out/share/redmine
      '' + lib.optionalString (propagatedPlugins != []) ''
        cp -r ${pluginEnv}/* $out/share/redmine/plugins/
      '';

      meta = with stdenv.lib; {
        homepage = http://www.redmine.org/;
        platforms = platforms.linux;
        maintainers = [ ];
        license = licenses.gpl2;
      };
    };
in
withPlugins []
