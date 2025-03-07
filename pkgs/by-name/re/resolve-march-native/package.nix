{
  python3Packages,
  fetchFromGitHub,
  gcc,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "resolve-march-native";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    tag = version;
    hash = "sha256-YJvKLHxn80RRVEOGeg9BwxhDZ8Hhg5Qa6ryLOXumY5w=";
  };

  # NB: The tool uses gcc at runtime to resolve the -march=native flags
  propagatedBuildInputs = [ gcc ];

  doCheck = true;

  meta = with lib; {
    description = "Tool to determine what GCC flags -march=native would resolve into";
    mainProgram = "resolve-march-native";
    homepage = "https://github.com/hartwork/resolve-march-native";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.unix;
  };
}
