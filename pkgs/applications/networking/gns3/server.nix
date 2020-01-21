{ stable, branch, version, sha256Hash, mkOverride }:

{ lib, stdenv, python3, fetchFromGitHub }:

let
  defaultOverrides = [
    (mkOverride "psutil" "5.6.3"
      "1wv31zly44qj0rp2acg58xbnc7bf6ffyadasq093l455q30qafl6")
    (mkOverride "jsonschema" "2.6.0"
      "00kf3zmpp9ya4sydffpifn0j0mzm342a2vzh82p6r0vh10cg7xbg")
  ];

  python = python3.override {
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) defaultOverrides;
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
