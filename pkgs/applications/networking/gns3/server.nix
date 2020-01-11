{ stable, branch, version, sha256Hash }:

{ lib, stdenv, python3, fetchFromGitHub
, packageOverrides ? self: super: {
}}:

let
  defaultOverrides = [
        (mkOverride "psutil" "5.6.3"
      "1wv31zly44qj0rp2acg58xbnc7bf6ffyadasq093l455q30qafl6")
        (mkOverride "jsonschema" "5.6.3"
      "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg")
        (mkOverride "aiohttp" "3.6.2"
        "09pkw6f1790prnrq0k8cqgnf1qy57ll8lpmc6kld09q7zw4vi6i5")
  ];

  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
        checkPhase = (
          # Match unstable branch, cookiejar missing from python packages..
          if attrname == "aiohttp" then ''
                 cd tests
                    pytest -k "not get_valid_log_format_exc \
                    and not test_access_logger_atoms \
                    and not aiohttp_request_coroutine \
                    and not server_close_keepalive_connection \
                    and not connector \
                    and not client_disconnect \
                    and not handle_keepalive_on_closed_connection \
                    and not proxy_https_bad_response \
                    and not partially_applied_handler \
                    and not middleware" \
                  --ignore=test_connector.py \
                  --ignore=test_cookiejar.py
            ''
            else if attrname == "jsonschema" then
              oldAttrs.checkPhase
            else 
              ''''
        );
      });
    };

  python = python3.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) ([ packageOverrides ] ++ defaultOverrides);
  };
    

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
    # yarl 1.4+ only requires Python 3.6+
    sed -iE "s/yarl==1.3.0//" requirements.txt
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp-cors yarl aiohttp multidict setuptools
    jinja2 psutil zipstream raven jsonschema distro async_generator aiofiles
    (python.pkgs.callPackage ../../../development/python-modules/prompt_toolkit/1.nix {})
  ];

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
