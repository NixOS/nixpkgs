{
  lib,
  dash,
  editorconfig,
  f,
  fetchFromGitHub,
  nodejs,
  s,
  melpaBuild,
}:
melpaBuild {
  pname = "copilot";
  version = "0-unstable-2024-05-01";

  src = fetchFromGitHub {
    owner = "copilot-emacs";
    repo = "copilot.el";
    rev = "733bff26450255e092c10873580e9abfed8a81b8";
    sha256 = "sha256-Knp36PtgA73gtYO+W1clQfr570bKCxTFsGW3/iH86A0=";
  };

  files = ''(:defaults "dist")'';

  packageRequires = [
    dash
    editorconfig
    f
    s
  ];

  propagatedUserEnvPkgs = [ nodejs ];

  meta = {
    description = "Unofficial copilot plugin for Emacs";
    homepage = "https://github.com/copilot-emacs/copilot.el";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
}
