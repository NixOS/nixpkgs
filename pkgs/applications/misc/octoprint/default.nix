{ pkgs
, stdenv
, lib
, fetchFromGitHub
, python3
, substituteAll
, nix-update-script
  # To include additional plugins, pass them here as an overlay.
, packageOverrides ? self: super: { }
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
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) (
      [
        # the following dependencies are non trivial to update since later versions introduce backwards incompatible
        # changes that might affect plugins, or due to other observed problems
        (mkOverride "click" "7.1.2" "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a")
        (mkOverride "flask-babel" "1.0.0" "0gmb165vkwv5v7dxsxa2i3zhafns0fh938m2zdcrv4d8z5l099yn")
        (mkOverride "itsdangerous" "1.1.0" "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19")
        (mkOverride "jinja2" "2.11.3" "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6")
        (mkOverride "markdown" "3.1.1" "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a")
        (mkOverride "markupsafe" "1.1.1" "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b")

        # Requires flask<2, cannot mkOverride because tests need to be disabled
        (
          self: super: {
            flask = super.flask.overridePythonAttrs (oldAttrs: rec {
              version = "1.1.4";
              src = oldAttrs.src.override {
                inherit version;
                sha256 = "15ni4xlm57a15f5hipp8w0c9zba20179bvfns2392fiq1lcbdghg";
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
              doCheck = false;
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
                version = "0.59.0";
                src = oldAttrs.src.override {
                  inherit version;
                  sha256 = "0p0cz2mdissq7iw1n7jrmsfir0jfmgs1dvnpnrx477ffx9hbsxnk";
                };
                propagatedBuildInputs = with self; [
                  six
                  pysocks
                ];
                disabledTests = [
                  "testConnect" # requires network access
                ];
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

        # Octoprint pulls in celery indirectly but has no support for the up-to-date releases
        (
          self: super: {
            celery = super.celery.overrideAttrs (oldAttrs: rec {
              version = "5.0.0";
              src = oldAttrs.src.override {
                inherit version;
                hash = "sha256-MTkw/d3nA9jjcCmjBL+RQpzRGu72PFfebayp2Vjh8lU=";
              };
              disabledTestPaths = [
                "t/unit/backends/test_mongodb.py"
              ];
            });
          }
        )

        # Octoprint would allow later sentry-sdk releases but not later click releases
        (
          self: super: {
            sentry-sdk = super.sentry-sdk.overrideAttrs (oldAttrs: rec {
              pname = "sentry-sdk";
              version = "1.4.3";

              src = fetchFromGitHub {
                owner = "getsentry";
                repo = "sentry-python";
                rev = version;
                sha256 = "sha256-vdE6eqELMM69CWHaNYhF0HMCTV3tQsJlMHAA96oCy8c=";
              };
              disabledTests = [
                "test_apply_simulates_delivery_info"
                "test_auto_enabling_integrations_catches_import_error"
                "test_leaks"
              ];
              disabledTestPaths = [
                # Don't test integrations
                "tests/integrations"
                # test crashes on aarch64
                "tests/test_transport.py"
              ];
            });
          }
        )

        # Octoprint fails due to a newly added test in pytest-httpbin
        # see https://github.com/NixOS/nixpkgs/issues/159864
        (
          self: super: {
            pytest-httpbin = super.pytest-httpbin.overridePythonAttrs (oldAttrs: rec {
              disabledTests = [
                "test_redirect_location_is_https_for_secure_server"
              ];
            });
          }
        )

        # All test fail on aarch64
        (
          self: super: {
            azure-core = super.azure-core.overridePythonAttrs (oldAttrs: rec {
              doCheck = stdenv.buildPlatform == "x86_64-linux";
            });
          }
        )

        # needs network
        (
          self: super: {
            falcon = super.falcon.overridePythonAttrs (oldAttrs: rec {
              #pytestFlagsArray = [ "-W ignore::DeprecationWarning" ];
              disabledTestPaths = oldAttrs.disabledTestPaths ++ [
                "tests/asgi/test_asgi_servers.py"
              ];
            });
          }
        )

        # update broke some tests
        (
          self: super: {
            sanic = super.sanic.overridePythonAttrs (oldAttrs: rec {
              disabledTestPaths = oldAttrs.disabledTestPaths ++ [
                "test_cli.py"
                "test_cookies.py"
                # requires network
                "test_worker.py"
              ];
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
              version = "2021.10.11";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-FirmwareCheck";
                rev = version;
                sha256 = "0hl0612x0h4pcwsrga5il5x3m04j37cmyzh2dg1kl971cvrw79n2";
              };
              doCheck = false;
            };
          }
        )

        (
          self: super: {
            octoprint-pisupport = self.buildPythonPackage rec {
              pname = "OctoPrint-PiSupport";
              version = "2021.10.28";
              format = "setuptools";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-PiSupport";
                rev = version;
                sha256 = "01bpvv1sn3113fdpw6b90c2rj8lqay118x609yy64z9ccm93khl9";
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
              version = "1.7.3";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint";
                rev = version;
                sha256 = "sha256-U6g7WysHHOlZ4p5BM4tw3GGAxQmxv6ltYgAp1rO/eCg=";
              };

              propagatedBuildInputs = with super; [
                blinker
                cachelib
                click
                colorlog
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
                pathvalidate
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
              ] ++ lib.optionals stdenv.isDarwin [
                py.pkgs.appdirs
              ];

              checkInputs = with super; [
                ddt
                mock
                pytestCheckHook
              ];

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

              postPatch =
                let
                  ignoreVersionConstraints = [
                    "cachelib"
                    "colorlog"
                    "emoji"
                    "immutabledict"
                    "PyYAML"
                    "sarge"
                    "sentry-sdk"
                    "watchdog"
                    "wrapt"
                    "zeroconf"
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
                license = licenses.agpl3Only;
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
