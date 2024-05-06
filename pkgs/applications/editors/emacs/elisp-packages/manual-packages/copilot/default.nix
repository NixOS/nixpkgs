{
  dash,
  editorconfig,
  f,
  fetchFromGitHub,
  nodejs,
  s,
  trivialBuild,
}:
trivialBuild {
  pname = "copilot";
  version = "unstable-2024-05-01";
  src = fetchFromGitHub {
    owner = "copilot-emacs";
    repo = "copilot.el";
    rev = "733bff26450255e092c10873580e9abfed8a81b8";
    sha256 = "sha256-Knp36PtgA73gtYO+W1clQfr570bKCxTFsGW3/iH86A0=";
  };
  packageRequires = [
    dash
    editorconfig
    f
    nodejs
    s
  ];

  meta = {
    description = "An unofficial copilot plugin for Emacs";
    homepage = "https://github.com/copilot-emacs/copilot.el";
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
}
