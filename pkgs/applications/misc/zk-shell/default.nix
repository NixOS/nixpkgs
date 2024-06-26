{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "zk-shell";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "rgs1";
    repo = "zk_shell";
    rev = "v${version}";
    sha256 = "0zisvvlclsf4sdh7dpqcl1149xbxw6pi1aqcwjbqblgf8m4nm0c7";
  };

  propagatedBuildInputs = with python3Packages; [
    ansi
    kazoo
    nose
    six
    tabulate
    twitter
  ];

  # requires a running zookeeper, don't know how to fix that for the moment
  doCheck = false;

  meta = with lib; {
    description = "Powerful & scriptable shell for Apache ZooKeeper";
    mainProgram = "zk-shell";
    homepage = "https://github.com/rgs1/zk_shell";
    license = licenses.asl20;
    maintainers = [ maintainers.mahe ];
    platforms = platforms.all;
  };
}
