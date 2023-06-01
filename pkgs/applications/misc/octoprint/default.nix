{ pkgs
, stdenv
, callPackage
, lib
, fetchFromGitHub
, python3
, substituteAll
, nix-update-script
, nixosTests
  # To include additional plugins, pass them here as an overlay.
, packageOverrides ? self: super: { }
}:
let

  py = python3.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) (
      [
        (
          # with version 3 of flask-limiter octoprint 1.8.7 fails to start with
          #  TypeError: Limiter.__init__() got multiple values for argument 'key_func'
          self: super: {
            flask-limiter = super.flask-limiter.overridePythonAttrs (oldAttrs: rec {
              version = "2.6.2";
              src = fetchFromGitHub {
                owner = "alisaifee";
                repo = "flask-limiter";
                rev = version;
                sha256 = "sha256-eWOdJ7m3cY08ASN/X+7ILJK99iLJJwCY8294fwJiDew=";
              };
            });
            flask-babel = super.flask-babel.overridePythonAttrs (oldAttrs: rec {
              version = "2.0.0";
              src = super.fetchPypi {
                pname = "Flask-Babel";
                inherit version;
                sha256 = "sha256-+fr0XNsuGjLqLsFEA1h9QpUQjzUBenghorGsuM/ZJX0=";
              };
              nativeBuildInputs = [ ];
              format = "setuptools";
              outputs = [ "out" ];
              patches = [ ];
            });
            # downgrade needed for flask-babel 2.0.0
            babel = super.babel.overridePythonAttrs (oldAttrs: rec {
              version = "2.11.0";
              src = super.fetchPypi {
                pname = "Babel";
                inherit version;
                hash = "sha256-XvSzImsBgN7d7UIpZRyLDho6aig31FoHMnLzE+TPl/Y=";
              };
              propagatedBuildInputs = [ self.pytz ];
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
                hash = "sha256-wqbD82bhJDrDawJ+X9kZkoA6eqGxqJc1Z5dA0EUwgEI=";
              };
              doCheck = false;
            };
          }
        )

        (
          self: super: {
            octoprint-pisupport = self.buildPythonPackage rec {
              pname = "OctoPrint-PiSupport";
              version = "2022.6.13";
              format = "setuptools";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-PiSupport";
                rev = version;
                hash = "sha256-3z5Btl287W3j+L+MQG8FOWt21smML0vpmu9BP48B9A0=";
              };

              # requires octoprint itself during tests
              doCheck = false;
              postPatch = ''
                substituteInPlace octoprint_pi_support/__init__.py \
                  --replace /usr/bin/vcgencmd ${self.pkgs.libraspberrypi}/bin/vcgencmd
              '';
            };
          }
        )

        (
          self: super: {
            octoprint = self.buildPythonPackage rec {
              pname = "OctoPrint";
              version = "1.8.7";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint";
                rev = version;
                hash = "sha256-g4PYB9YbkX0almRPgMFlb8D633Y5fc3H+Boa541suqc=";
              };

              propagatedBuildInputs = with self; [
                argon2-cffi
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
                flask-login
                flask-limiter
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
                passlib
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
                zipstream-ng
              ] ++ lib.optionals stdenv.isDarwin [
                py.pkgs.appdirs
              ];

              nativeCheckInputs = with self; [
                ddt
                mock
                pytestCheckHook
              ];

              patches = [
                # substitute pip and let it find out, that it can't write anywhere
                (substituteAll {
                  src = ./pip-path.patch;
                  pip = "${self.pip}/bin/pip";
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
                    "Flask-Login"
                    "werkzeug"
                    "flask"
                    "Flask-Limiter"
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
                inherit (self) python;
                updateScript = nix-update-script { };
                tests = {
                  plugins = (callPackage ./plugins.nix { }) super self;
                  inherit (nixosTests) octoprint;
                };
              };

              meta = with lib; {
                homepage = "https://octoprint.org/";
                description = "The snappy web interface for your 3D printer";
                license = licenses.agpl3Only;
                maintainers = with maintainers; [ abbradar gebner WhittlesJr gador ];
              };
            };
          }
        )
        (callPackage ./plugins.nix { })
        packageOverrides
      ]
    );
  };
in
with py.pkgs; toPythonApplication octoprint
