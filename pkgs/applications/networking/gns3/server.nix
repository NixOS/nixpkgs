{ stable, branch, version, sha256Hash, mkOverride, commonOverrides }:

{ lib, python3, fetchFromGitHub, packageOverrides ? self: super: {}
 }:

let
  defaultOverrides = commonOverrides ++ [
    (self: super: {
      aiofiles = super.aiofiles.overridePythonAttrs (oldAttrs: rec {
        pname = "aiofiles";
        version = "0.7.0";
        src = fetchFromGitHub {
          owner = "Tinche";
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-njQ7eRYJO+dUrwO5pZwKHXn9nVSGYcEhwhs3x5BMc28=";
        };
        doCheck = false;
      });

      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.2.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-yKhbKNN3zHc35G4tnytPRO48Dh3qxr9G3e/HGH0weXo=";
        };

        SETUPTOOLS_SCM_PRETEND_VERSION = version;

        doCheck = false;
      });

    })
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };
in python.pkgs.buildPythonApplication {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-server";
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "aiohttp==3.7.4" "aiohttp>=3.7.4" \
      --replace "Jinja2==3.0.1" "Jinja2>=3.0.1" \
      --replace "sentry-sdk==1.3.1" "sentry-sdk>=1.3.1" \
      --replace "async-timeout==3.0.1" "async-timeout>=3.0.1" \
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp-cors yarl aiohttp multidict setuptools
    jinja2 psutil zipstream sentry-sdk jsonschema distro async_generator aiofiles
    prompt-toolkit py-cpuinfo
  ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with lib; {
    description = "Graphical Network Simulator 3 server (${branch} release)";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = "https://www.gns3.com/";
    changelog = "https://github.com/GNS3/gns3-server/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
