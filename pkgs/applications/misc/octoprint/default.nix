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

  py = python3.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) (
      [
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
              version = "2022.3.28";
              format = "setuptools";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint-PiSupport";
                rev = version;
                sha256 = "yzE/jz604nX/CHcW3aa7goH1ey8qZ7rLw31SMfNKJZM=";
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
              version = "1.8.1";

              src = fetchFromGitHub {
                owner = "OctoPrint";
                repo = "OctoPrint";
                rev = version;
                sha256 = "sha256-9phB9B8y3ay1Bsvf/m/E9xdl7vmQur4qbWOw9v6KFak=";
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
                zipstream-ng
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
                    "Flask-Login"
                    "werkzeug"
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
                maintainers = with maintainers; [ abbradar gebner WhittlesJr gador ];
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
