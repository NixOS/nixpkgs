{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "sublist3r";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "aboul3la";
    repo = "Sublist3r";
    rev = "refs/heads/master"; # Alternatively, use a specific commit or tag
    sha256 = "0iz94bqsx6v4jj68h4673hq5z1ymlbcjrm8ybnb0w7q863gdpfcy";
  };

  # List dependencies needed by the package
  propagatedBuildInputs = with python3Packages; [ requests dnspython ];

  # Outputs, if there are specific directories/files to expose
  outputs = [ "out" ];

  # Specify any additional post-install steps, if needed
  postInstall = ''
    # If Sublist3r includes any additional files to install, you can handle them here.
  '';

  # Disable tests if necessary; otherwise, configure `checkPhase` for running tests.
  doCheck = false;

  meta = with lib; {
    description = "Fast subdomains enumeration tool for penetration testers";
    longDescription = ''
      Sublist3r is a tool designed to enumerate subdomains for websites using OSINT.
      It helps penetration testers and bug hunters collect subdomains across various
      data sources and provides a quick overview of the target's surface area.
    '';
    homepage = "https://github.com/aboul3la/Sublist3r";
    license = licenses.gpl3Plus;
    maintainers = with maintainers;
      [ PNP-MA ]; # Replace with your Nixpkgs username
    platforms = platforms.all;
  };
}

