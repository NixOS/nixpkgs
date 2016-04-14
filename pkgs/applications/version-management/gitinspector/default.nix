{ stdenv, fetchzip, buildPythonPackage }:

buildPythonPackage rec {
  name = "gitinspector-${version}";
  version = "0.4.4";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/ejwa/gitinspector/archive/v${version}.tar.gz";
    sha256 = "1pfsw6xldm6jigs3nhysvqaxk8a0zf8zczgfkrp920as9sya3c7m";
    name = name + "-src";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ejwa/gitinspector;
    description = "Statistical analysis tool for git repositories";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
