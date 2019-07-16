{ stable, branch, version, sha256Hash }:

{ stdenv, python3, fetchFromGitHub }:

let
  python = if stable then python3.override {
    packageOverrides = self: super: {
      async-timeout = super.async-timeout.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1l3kg062m02mph6rf9rdv8r5c5n356clxa6b6mrn0i77vk9g9kq0";
        };
      });
      aiohttp = super.aiohttp.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.10";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964";
        };
        propagatedBuildInputs = with self; [ async-timeout attrs chardet multidict yarl idna-ssl ];
        doCheck = false;
      });
      aiohttp-cors = super.aiohttp-cors.overridePythonAttrs (oldAttrs: rec {
        version = "0.6.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1r0mb4dw0dc1lpi54dk5vxqs06nyhvagp76lyrvk7rd94z5mjkd4";
        };
        propagatedBuildInputs = with self; [ aiohttp ]
          ++ stdenv.lib.optional (pythonOlder "3.5") typing;
      });
    };
  } else python3;

in python.pkgs.buildPythonPackage {
  pname = "gns3-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "gns3-server";
    rev = "v${version}";
    sha256 = sha256Hash;
  };

  postPatch = ''
    # Only 2.x is problematic:
    sed -iE "s/prompt-toolkit==1.0.15/prompt-toolkit<2.0.0/" requirements.txt
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp-cors yarl aiohttp multidict
    jinja2 psutil zipstream raven jsonschema
    (python.pkgs.callPackage ../../../development/python-modules/prompt_toolkit/1.nix {})
  ] ++ stdenv.lib.optional (!stable) [ distro async_generator aiofiles ];

  # Requires network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/gns3loopback # For Windows only
  '';

  meta = with stdenv.lib; {
    description = "Graphical Network Simulator 3 server (${branch} release)";
    longDescription = ''
      The GNS3 server manages emulators such as Dynamips, VirtualBox or
      Qemu/KVM. Clients like the GNS3 GUI control the server using a HTTP REST
      API.
    '';
    homepage = https://www.gns3.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
