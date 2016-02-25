{ stdenv, fetchzip, buildPythonApplication }:

buildPythonApplication rec {
  name = "gitinspector-${version}";
  version = "0.4.1";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/ejwa/gitinspector/archive/v${version}.tar.gz";
    sha256 = "07kjvf9cj6g6gvjgnnas5facm3nhxppf0l0fcxyd4vq6xhdb3swp";
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
