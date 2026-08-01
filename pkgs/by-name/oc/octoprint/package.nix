{
  pkgs,
  stdenv,
  callPackage,
  lib,
  fetchFromGitHub,
  # OctoPrint requires Python >=3.7, <3.14, so it cannot use the default python3
  # while that points at 3.14.
  python313,
  replaceVars,
  nix-update-script,
  nixosTests,
  # To include additional plugins, pass them here as an overlay.
  packageOverrides ? self: super: { },
}:
let

  py = python313.override {
    self = py;
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) [
      # Built-in dependency
      (self: super: {
        octoprint-filecheck = self.buildPythonPackage rec {
          pname = "OctoPrint-FileCheck";
          version = "2025.7.23";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-FileCheck";
            rev = version;
            hash = "sha256-Y3JVfbe+bZz2t65OqdjvVVqTSa0VUPoCaxvE+zQ+Qts=";
          };
          doCheck = false;
        };
      })

      # Built-in dependency
      (self: super: {
        octoprint-firmwarecheck = self.buildPythonPackage rec {
          pname = "OctoPrint-FirmwareCheck";
          version = "2025.7.23";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-FirmwareCheck";
            rev = version;
            hash = "sha256-QPchpyeotB5IKbfES74CJlhw3sz8Q1df/+n5dpbrHSs=";
          };
          doCheck = false;
        };
      })

      (self: super: {
        octoprint-pisupport = self.buildPythonPackage rec {
          pname = "OctoPrint-PiSupport";
          version = "2025.7.23";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint-PiSupport";
            rev = version;
            hash = "sha256-bXjRGxIwi+UnVts2HO9viOJqa2AmZ/CL7wuoyzRbAEw=";
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
          version = "1.11.8";
          format = "setuptools";

          src = fetchFromGitHub {
            owner = "OctoPrint";
            repo = "OctoPrint";
            rev = version;
            hash = "sha256-yTHzBqwVxAP6EokiWqD/SR6P2X4gIGyiyzNH0UzzDB4=";
          };

          propagatedBuildInputs =
            with self;
            [
              argon2-cffi
              babel
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
              jinja2
              libpass
              limits
              markdown
              markupsafe
              netaddr
              netifaces
              octoprint-filecheck
              octoprint-firmwarecheck
              packaging
              pathvalidate
              pip
              pkginfo
              psutil
              pylru
              pyserial
              pytz
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
              wheel
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
            time-machine
            pytestCheckHook
          ];

          patches = [
            # substitute pip and let it find out, that it can't write anywhere
            (replaceVars ./pip-path.patch {
              pip = "${self.pip}/bin/pip";
            })

            # hardcore path to ffmpeg and hide related settings
            (replaceVars ./ffmpeg-path.patch {
              ffmpeg = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
            })
          ];

          postPatch =
            let
              ignoreVersionConstraints = [
                "Babel"
                "cachelib"
                "Click"
                "colorlog"
                "emoji"
                "limits"
                "markdown"
                "netaddr"
                "psutil"
                "PyYAML"
                "requests"
                "sarge"
                "sentry-sdk"
                "watchdog"
                "websocket-client"
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
                  map (e: ''-e 's@${e}[<>=!]+.*@${e}",@g' \'') ignoreVersionConstraints
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
            "tests/http_api" # requires a live OctoPrint server; excluded by upstream pytest.ini
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

          meta = {
            homepage = "https://octoprint.org/";
            description = "Snappy web interface for your 3D printer";
            mainProgram = "octoprint";
            license = lib.licenses.agpl3Only;
            maintainers = with lib.maintainers; [
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
