{
  python3Packages,
  fetchFromGitHub,
  gcc,
  lib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "resolve-march-native";
  version = "6.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "resolve-march-native";
    tag = finalAttrs.version;
    hash = "sha256-YJvKLHxn80RRVEOGeg9BwxhDZ8Hhg5Qa6ryLOXumY5w=";
  };

  # NB: The tool uses gcc at runtime to resolve the -march=native flags
  propagatedBuildInputs = [ gcc ];

  doCheck = true;

  meta = {
    description = "Tool to determine what GCC flags -march=native would resolve into";
    mainProgram = "resolve-march-native";
    homepage = "https://github.com/hartwork/resolve-march-native";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = lib.platforms.unix;
  };
})
