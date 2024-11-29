{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  setuptools,
  sphinx,
  sphinx-autoapi,
  sphinx-prompt,
  sphinx-rtd-theme,
  sphinx-tabs,
  sphinxemoji,
  sphinxHook,
}:

# Latest tagged release release "1.1.2" (Nov 2018) does not contain
# documenation, it was added in commits Aug 10, 2019. Repository does not have
# any activity since then.
buildPythonPackage {
  pname = "sphinx-version-warning";
  version = "unstable-2019-08-10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "humitos";
    repo = "sphinx-version-warning";
    rev = "a82156c2ea08e5feab406514d0ccd9d48a345f48";
    hash = "sha256-WnJYMk1gPLT0dBn7lmxVDNVkLYkDCgQOtM9fQ3kc6k0=";
  };

  # It tries to write to file relative to it own location at runtime
  # and gets permission denied, since Nix store is immutable.
  patches = [
    (fetchpatch {
      url = "https://github.com/humitos/sphinx-version-warning/commit/cb1b47becf2a0d3b2570ca9929f42f7d7e472b6f.patch";
      hash = "sha256-Vj0QAHIBmc0VxE+TTmJePzvr5nc45Sn2qqM+C/pkgtM=";
    })
  ];

  nativeBuildInputs = [
    sphinx-autoapi
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinxemoji
    sphinxHook
    setuptools
  ];

  buildInputs = [ sphinx ];

  pythonImportsCheck = [ "versionwarning" ];

  meta = with lib; {
    description = "Sphinx extension to show a warning banner at the top of your documentation";
    homepage = "https://github.com/humitos/sphinx-version-warning";
    changelog = "https://github.com/humitos/sphinx-version-warning/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
