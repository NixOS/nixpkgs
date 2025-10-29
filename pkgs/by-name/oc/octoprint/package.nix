{
  pkgs,
  stdenv,
  callPackage,
  lib,
  fetchFromGitHub,
  python3,
  replaceVars,
  nix-update-script,
  nixosTests,
  # To include additional plugins, pass them here as an overlay.
  packageOverrides ? self: super: { },
}:
let

  py = python3.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) [
      (

        self: super: {
          # fix tornado.httputil.HTTPInputError: Multiple host headers not allowed
          tornado = super.tornado.overridePythonAttrs (oldAttrs: {
            version = "6.4.2";
            format = "setuptools";
            pyproject = null;
            src = fetchFromGitHub {
              owner = "tornadoweb";
              repo = "tornado";
              tag = "v6.4.2";
              hash = "sha256-qgJh8pnC1ALF8KxhAYkZFAc0DE6jHVB8R/ERJFL4OFc=";
            };
            doCheck = false;
          });
        })
      # Built-in dependency
      (self: super: {
        octoprint-filecheck = self.buildPythonPackage rec {
          pname = "OctoPrint-FileCheck";
          version = "2024.11.12";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-FileCheck";
            rev = version;
            sha256 = "sha256-Y7yvImnYahmrf5GC4c8Ki8IsOZ8r9I4uk8mYBhEQZ28=";
          };
          doCheck = false;
        };
      })

      # Built-in dependency
      (self: super: {
        octoprint-firmwarecheck = self.buildPythonPackage rec {
          pname = "OctoPrint-FirmwareCheck";
          version = "2021.10.11";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-FirmwareCheck";
            rev = version;
            hash = "sha256-wqbD82bhJDrDawJ+X9kZkoA6eqGxqJc1Z5dA0EUwgEI=";
          };
          doCheck = false;
        };
      })

      (self: super: {
        octoprint-pisupport = self.buildPythonPackage rec {
          pname = "OctoPrint-PiSupport";
          version = "2023.10.10";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-PiSupport";
            rev = version;
            hash = "sha256-VSzDoFq4Yn6KOn+RNi1uVJHzH44973kd/VoMjqzyBRA=";
          };

          # requires octoprint itself during tests
          doCheck = false;
          postPatch = ''
            substituteInPlace octoprint_pi_support/__init__.py \
              --replace /usr/bin/vcgencmd ${self.pkgs.libraspberrypi}/bin/vcgencmd
          '';
        };
      })

      (self: super: {
        octoprint = self.buildPythonPackage rec {
          pname = "OctoPrint";
          version = "1.11.3";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint";
            rev = version;
            hash = "sha256-AyRi9aQXLFggBzc6WH2kvRPkJu1ANX/++GdCJRNhY/A=";
          };

          propagatedBuildInputs =
            with self;
            [
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
              flask-assets
              flask-login
              flask-limiter
              frozendict
              itsdangerous
              immutabledict
              jinja2
              markdown
              markupsafe
              netaddr
              netifaces
              octoprint-filecheck
              octoprint-firmwarecheck
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
              class-doc
              pydantic
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [ py.pkgs.appdirs ]
            ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ octoprint-pisupport ];

          nativeCheckInputs = with self; [
            ddt
            mock
            pytestCheckHook
          ];

          patches = [
            # substitute pip and let it find out, that it can't write anywhere
            (replaceVars ./pip-path.patch {
              pip = "${self.pip}/bin/pip";
            })

            # hardcore path to ffmpeg and hide related settings
            (replaceVars ./ffmpeg-path.patch {
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
                "blinker"
              ];
            in
            ''
              sed -r -i \
                ${lib.concatStringsSep "\n" (
                  map (e: ''-e 's@${e}[<>=]+.*@${e}",@g' \'') ignoreVersionConstraints
                )}
                setup.py
            '';

          preCheck = ''
            export HOME=$(mktemp -d)
            rm pytest.ini
          '';

          disabledTests = [
            "test_check_setup" # Why should it be able to call pip?
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_set_external_modification" ];
          disabledTestPaths = [
            "tests/test_octoprint_setuptools.py" # fails due to distutils and python3.12
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
            description = "Snappy web interface for your 3D printer";
            mainProgram = "octoprint";
            license = licenses.agpl3Only;
            maintainers = with maintainers; [
              WhittlesJr
              gador
            ];
          };
        };
      })
      (callPackage ./plugins.nix { })
      packageOverrides
    ];
  };
in
with py.pkgs;
toPythonApplication octoprint
