{
  lib,
  dash,
  editorconfig,
  f,
  fetchFromGitHub,
  replaceVars,
  nodejs,
  s,
  melpaBuild,
  copilot-node-server,
}:
melpaBuild {
  pname = "copilot";
  version = "0-unstable-2024-12-28";

  src = fetchFromGitHub {
    owner = "copilot-emacs";
    repo = "copilot.el";
    rev = "c5dfa99f05878db5e6a6a378dc7ed09f11e803d4";
    sha256 = "sha256-FzI08AW7a7AleEM7kSQ8LsWsDYID8SW1SmSN6/mIB/A=";
  };

  files = ''(:defaults "dist")'';

  patches = [
    (replaceVars ./specify-copilot-install-dir.patch {
      copilot-node-server = copilot-node-server;
    })
  ];
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
