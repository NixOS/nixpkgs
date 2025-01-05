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
let
  # The Emacs package isn't compatible with the latest
  # copilot-node-server so we have to set a specific revision
  # https://github.com/copilot-emacs/copilot.el/issues/344
  pinned-copilot-node-server = copilot-node-server.overrideAttrs (old: rec {
    version = "1.27.0";
    src = fetchFromGitHub {
      owner = "jfcherng";
      repo = "copilot-node-server";
      rev = version;
      hash = "sha256-Ds2agoO7LBXI2M1dwvifQyYJ3F9fm9eV2Kmm7WITgyo=";
    };
  });
in
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
      copilot-node-server = pinned-copilot-node-server;
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
