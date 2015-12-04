{ pkgs, fetchurl, lib, pythonPackages, ...}:

pythonPackages.buildPythonPackage rec {

  name = "fc.agent-${version}";
  version = "1.7.8";

  buildInputs = with pythonPackages; [
  ];

  propagatedBuildInputs = with pythonPackages; [
    configobj
    iso8601
    ldap
    netaddr
    pkgs.nagiosplugin
    pytest
    pytz
    pyyaml
    requests2
    shortuuid
    six
  ];

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/f/fc.agent/fc.agent-${version}.tar.gz";
    md5 = "3960a74a6d38097eb03a25c226959d21";
  };

  meta = {
    description = "Local configuration utilities and helper APIs for flyingcircus.io system configuration.";
    homepage = http://bitbucket.org/flyingcircus/fc.agent;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.zagy ];
  };
}
