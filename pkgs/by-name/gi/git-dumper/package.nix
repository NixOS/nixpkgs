{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-dumper";
  version = "1.0.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arthaud";
    repo = "git-dumper";
    tag = finalAttrs.version;
    hash = "sha256-VFWYoXCZ+ec5StKW0cZ6Jj2zcxdeneyvjUB2L8Iy/Q4=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    dulwich
    pysocks
    requests
    requests-pkcs12
  ];

  pythonImportsCheck = [ "git_dumper" ];

  # No python tests nor version flag
  doCheck = false;

  meta = {
    description = "Tool to dump a git repository from a website";
    homepage = "https://github.com/arthaud/git-dumper";
    changelog = "https://github.com/arthaud/git-dumper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yechielw ];
    mainProgram = "git-dumper";
  };
})
