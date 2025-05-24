{
  lib,
  fetchFromGitHub,
  python3,
}:
let
  kivymd_0_104_1 = python3.pkgs.kivymd.overridePythonAttrs (old: {
    src = (
      old.src.override {
        version = "0.104.1";
        hash = "sha256-ncvCy4r/3pyCVyGY/dsyyBTN1XJUoOSwDFOILbLI1qY=";
      }
    );
  });
in
python3.pkgs.buildPythonApplication rec {
  pname = "katrain";
  version = "v1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanderland";
    repo = "katrain";
    tag = version;
    hash = "sha256-v0VGjxayXLbBSXs/jkYeXgbyDg+JFLgxESDuh/qbg1U=";
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    docutils
    ffpyplayer
    kivy
    kivymd_0_104_1
    pygame
    screeninfo
    urllib3
  ];

  meta = with lib; {
    homepage = "https://github.com/sanderland/katrain";
    description = "Improve your Baduk skills by training with KataGo!";
    longDescription = ''
      Katrain is a Baduk (Go) GUI built around the KataGo GTP engine.

      To fully utilize it, you should have:
      - `xclip`: For clipboard integration with SGF files.
      - `katago`: The actual AI engine that powers the analysis.

      Both can be installed separately as:
      pkgs.xclip (or pkgs.wl-clipboard-x11 for Wayland)
      pkgs.katago

      Alternatively, you can run:
      $ nix-shell -p xclip katago
    '';
    mainProgram = "katrain";
    license = "https://github.com/sanderland/katrain/blob/master/LICENSE";
    maintainers = with maintainers; [ iofq ];
  };
}
