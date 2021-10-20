{ pkgs
, stdenv
, lib
, fetchFromGitHub
, python38
, substituteAll
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

  py = python38.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: {}) (
      [
        # the following dependencies are non trivial to update since later versions introduce backwards incompatible
        # changes that might affect plugins, or due to other observed problems
        (mkOverride "click" "7.1.2" "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a")
        (mkOverride "flask-babel" "1.0.0" "0gmb165vkwv5v7dxsxa2i3zhafns0fh938m2zdcrv4d8z5l099yn")
        (mkOverride "itsdangerous" "1.1.0" "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19")
        (mkOverride "jinja2" "2.11.3" "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6")
        (mkOverride "markdown" "3.1.1" "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a")
        (mkOverride "markupsafe" "1.1.1" "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b")
        (mkOverride "sarge" "0.1.5.post0" "1c1ll7pys9vra5cfi8jxlgrgaql6c27l6inpy15aprgqhc4ck36s")
        (mkOverride "tornado" "5.1.1" "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409")

        # Requires flask<2, cannot mkOverride because tests need to be disabled
        (
          self: super: {
            flask = super.flask.overridePythonAttrs (oldAttrs: rec {
              version = "1.1.2";
              src = oldAttrs.src.override {
                inherit version;
                sha256 = "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060";
              };
              doCheck = false;
            });
          }
        )

        # Requires werkezug<2, cannot mkOverride because tests need to be disabled
        (
          self: super: {
            werkzeug = super.werkzeug.overridePythonAttrs (oldAttrs: rec {
              version = "1.0.1";
              src = oldAttrs.src.override {
                inherit version;
                sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
              };
              doCheck= false;
            });
          }
        )

        # Requires unidecode>=0.04.14,<0.05. Upstream changed the source naming between releases
        (
          self: super: {
            unidecode = super.unidecode.overridePythonAttrs (oldAttrs: rec {
              version = "0.04.21";
              src = fetchFromGitHub {
                owner = "avian2";
                repo = "unidecode";
                rev = "release-${version}";
                sha256 = "0p5bkibv0xm1265dlfrz3zq3k9bbx07gl8zyq8mvvb8hi7p5lifg";
              };
            });
          }
        )

        # Requires websocket-client <1.0, >=0.57. Cannot do mkOverride b/c differing underscore/hyphen in pypi source name
        (
          self: super: {
            websocket-client = super.websocket-client.overridePythonAttrs (
              oldAttrs: rec {
                version = "0.58.0";
                src = oldAttrs.src.override {
                  pname = "websocket_client";
                  inherit version;
                  sha256 = "63509b41d158ae5b7f67eb4ad20fecbb4eee99434e73e140354dc3ff8e09716f";
                };
                propagatedBuildInputs = [ self.six ];
              }
            );
          }
        )

        # Octoprint needs zeroconf >=0.24 <0.25. This can't be done via mkOverride, because in zeroconf 0.32
        # the super package was migrated to fetchFromGitHub.
        (
          self: super: {
            zeroconf = super.zeroconf.overrideAttrs (oldAttrs: rec {
              version = "0.24.5";
              src = super.fetchPypi {
                inherit (oldAttrs) pname;
                inherit version;
                sha256 = "0jpgd0rk91si93857mjrizan5gc42kj1q4fi4160qgk68la88fl9";
              };
              pythonImportsCheck = [
                "zeroconf"
              ];
              buildInputs = with self; [
                pytestCheckHook
                nose
              ];
              pytestFlagsArray = [ "zeroconf/test.py" ];
            });
          }
        )

        # Built-in dependency
        (
          self: super: {
            octoprint-filecheck = self.buildPythonPackage rec {
              pname = "OctoPrint-FileCheck";
              version = "2021.2.23";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-FileCheck";
                rev = version;
                sha256 = "sha256-e/QGEBa9+pjOdrZq3Zc6ifbSMClIyeTOi0Tji0YdVmI=";
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
              version = "2021.8.11";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-FirmwareCheck";
                rev = version;
                sha256 = "sha256-WzVjHgjF12iJ642AFaFd86GSU90XyPzKhi1CSreynW4=";
              };
              doCheck = false;
            };
          }
        )

        (
          self: super: {
            octoprint-pisupport = self.buildPythonPackage rec {
              pname = "OctoPrint-PiSupport";
              version = "2021.8.2";
              format = "setuptools";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-PiSupport";
                rev = version;
                sha256 = "07akx61wadxhs0545pqa9gzjnaz9742bq710f8f4zs5x6sacjzbc";
              };

              # requires octoprint itself during tests
              doCheck = false;
            };
          }
        )

        (
          self: super: {
            octoprint = self.buildPythonPackage rec {
              pname = "OctoPrint";
              version = "1.6.1";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint";
                rev = version;
                sha256 = "sha256-3b3k9h8H9Spf/P3/pXpCANnSGOgbUw/EWISJbrSoPBM=";
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
                immutabledict
                jinja2
                markdown
                markupsafe
                netaddr
                netifaces
                octoprint-filecheck
                octoprint-firmwarecheck
                octoprint-pisupport
                pkginfo
                pip
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
                setuptools
                tornado
                unidecode
                watchdog
                websocket-client
                werkzeug
                wrapt
                zeroconf
                zipstream-new
              ] ++ lib.optionals stdenv.isDarwin [ py.pkgs.appdirs ];

              checkInputs = with super; [ pytestCheckHook mock ddt ];

              patches = [
                # substitute pip and let it find out, that it can't write anywhere
                (substituteAll {
                  src = ./pip-path.patch;
                  pip = "${super.pip}/bin/pip";
                })

                # hardcore path to ffmpeg and hide related settings
                (substituteAll {
                  src = ./ffmpeg-path.patch;
                  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
                })
              ];

              postPatch = let
                ignoreVersionConstraints = [
                  "emoji"
                  "immutabledict"
                  "sentry-sdk"
                  "watchdog"
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
