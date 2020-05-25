{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.0.0";
  name = "zk-shell-" + version;

  src = fetchFromGitHub {
    owner = "rgs1";
    repo = "zk_shell";
    rev = "v${version}";
    sha256 = "0zisvvlclsf4sdh7dpqcl1149xbxw6pi1aqcwjbqblgf8m4nm0c7";
  };

  propagatedBuildInputs = (with pythonPackages; [
    ansi kazoo nose six tabulate twitter
  ]);

  #requires a running zookeeper, don't know how to fix that for the moment
  doCheck = false;

  meta = {
    description = "A powerful & scriptable shell for Apache ZooKeeper";
    homepage = "https://github.com/rgs1/zk_shell";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.mahe ];
    platforms = stdenv.lib.platforms.all;
  };
}
