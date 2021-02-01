{ pkgs
, stdenv
, lib
, fetchFromGitHub
, python3
, nix-update-script
  # To include additional plugins, pass them here as an overlay.
, packageOverrides ? self: super: {}
}:
let
  mkOverride = attrname: version: sha256:
  self: super: {
    ${attrname} = super.${attrname}.overridePythonAttrs (
      oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      }
    );
  };

  py = python3.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: {}) (
      [
        # the following dependencies are non trivial to update since later versions introduce backwards incompatible
        # changes that might affect plugins, or due to other observed problems
        (mkOverride "flask-babel" "1.0.0" "0gmb165vkwv5v7dxsxa2i3zhafns0fh938m2zdcrv4d8z5l099yn")
        (mkOverride "rsa" "4.0" "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487")
        (mkOverride "markdown" "3.1.1" "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a")
        (mkOverride "tornado" "5.1.1" "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409")
        (mkOverride "unidecode" "0.04.21" "280a6ab88e1f2eb5af79edff450021a0d3f0448952847cd79677e55e58bad051")
        (mkOverride "sarge" "0.1.5.post0" "1c1ll7pys9vra5cfi8jxlgrgaql6c27l6inpy15aprgqhc4ck36s")

        # Octoprint needs zeroconf >=0.24 <0.25. While this should be done in
        # the mkOverride aboves, this package also has broken tests, so we need
        # a proper override.
        (
          self: super: {
            zeroconf = super.zeroconf.overrideAttrs (oldAttrs: rec {
              version = "0.24.5";
              src = oldAttrs.src.override {
                inherit version;
                sha256 = "0jpgd0rk91si93857mjrizan5gc42kj1q4fi4160qgk68la88fl9";
              };
              buildInputs = [ self.nose ];
              checkPhase = "nosetests";
            });
          }
        )

        # Built-in dependency
        (
          self: super: {
            octoprint-filecheck = self.buildPythonPackage rec {
              pname = "OctoPrint-FileCheck";
              version = "2020.08.07";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-FileCheck";
                rev = version;
                sha256 = "05ys05l5x7d2bkg3yqrga6m65v3g5fcnnzbfab7j9w2pzjdapx5b";
              };
              doCheck = false;
            };
          }
        )

        # Built-in dependency
        (
          self: super: {
            octoprint-firmwarecheck = self.buildPythonPackage rec {
              pname = "OctoPrint-FirmwareCheck";
              version = "2020.09.23";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-FirmwareCheck";
                rev = version;
                sha256 = "1l1ajhnsc39prgk59mp93h90dgl9gh660cci00z5b5gj2h6dv1d1";
              };
              doCheck = false;
            };
          }
        )

        (
          self: super: {
            octoprint = self.buildPythonPackage rec {
              pname = "OctoPrint";
              version = "1.5.3";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint";
                rev = version;
                sha256 = "sha256-ZL/P/YIHynPmP8ssZZUKZDJscBsSsCq3UtOHrTVLpec=";
              };

              propagatedBuildInputs = with super; [
                blinker
                cachelib
                click
                emoji
                feedparser
                filetype
                flask
                flask-babel
                flask_assets
                flask_login
                frozendict
                future
                itsdangerous
                jinja2
                markdown
                markupsafe
                netaddr
                netifaces
                octoprint-filecheck
                octoprint-firmwarecheck
                pkginfo
                psutil
                pylru
                pyserial
                pyyaml
                regex
                requests
                rsa
                sarge
                semantic-version
                sentry-sdk
                tornado
                unidecode
                watchdog
                websocket_client
                werkzeug
                wrapt
                zeroconf
              ] ++ lib.optionals stdenv.isDarwin [ py.pkgs.appdirs ];

              checkInputs = with super; [ pytestCheckHook mock ddt ];

              postPatch = let
                ignoreVersionConstraints = [
                  "sentry-sdk"
                ];
              in
                ''
                  sed -r -i \
                    ${lib.concatStringsSep "\n" (
                  map (
                    e:
                      ''-e 's@${e}[<>=]+.*@${e}",@g' \''
                  ) ignoreVersionConstraints
                )}
                    setup.py
                '';

              dontUseSetuptoolsCheck = true;

              preCheck = ''
                export HOME=$(mktemp -d)
                rm pytest.ini
              '';

              disabledTests = [
                "test_check_setup" # Why should it be able to call pip?
              ] ++ lib.optionals stdenv.isDarwin [
                "test_set_external_modification"
              ];

              passthru = {
                python = self.python;
                updateScript = nix-update-script { attrPath = "octoprint"; };
              };

              meta = with lib; {
                homepage = "https://octoprint.org/";
                description = "The snappy web interface for your 3D printer";
                license = licenses.agpl3;
                maintainers = with maintainers; [ abbradar gebner WhittlesJr ];
              };
            };
          }
        )
        (import ./plugins.nix { inherit pkgs; })
        packageOverrides
      ]
    );
  };
in
  with py.pkgs; toPythonApplication octoprint
