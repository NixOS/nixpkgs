{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cpuset";
  version = "1.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lpechacek";
    repo = "cpuset";
    rev = "v${version}";
    hash = "sha256-fW0SXNI10pb6FTn/2TOqxP9qlys0KL/H9m//NjslUaY=";
  };

  makeFlags = [ "prefix=$(out)" ];

  checkPhase = ''
    runHook preCheck

    make -C t

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python application that forms a wrapper around the standard Linux filesystem calls, to make using the cpusets facilities in the Linux kernel easier";
    homepage = "https://github.com/SUSE/cpuset";
    license = licenses.gpl2;
    mainProgram = "cset";
    maintainers = with maintainers; [ wykurz ];
    platforms = platforms.linux;
  };
}
