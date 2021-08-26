{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, application, lxml, gevent, eventlib, ... }:

buildPythonPackage rec {
  pname = "python3-xcaplib";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-xcaplib";
    rev = "aadeed49be31ef25cc7a4c32aa7f50fee0e79d72";
    sha256 = "sha256-Hp23msHe6Mey3ZZOvvXJ5dGDF1n4DfoZlW8yXFY6Oaw=";
  };

  propagatedBuildInputs = [ lxml gevent eventlib application ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python XCAP client library";
    homepage = "https://github.com/AGProjects/python3-xcaplib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      XCAP protocol, defined in RFC 4825, allows a client to read, write, and
      modify application configuration data stored in XML format on a server. XCAP
      maps XML document sub-trees and element attributes to HTTP URIs, so that
      these components can be directly accessed by HTTP. An XCAP server used by
      XCAP clients to store data like presence policy in combination with a SIP
      Presence server that supports PUBLISH/SUBSCRIBE/NOTIFY SIP methods can
      provide a complete SIP SIMPLE solution.

      The XCAP client example script provided by this package can be used to
      manage documents on an XCAP server.
    '';
  };
}
