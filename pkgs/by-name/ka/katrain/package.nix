{
  lib,
  fetchFromGitHub,
  python3,
}:
let
  kivymd_0_104_1 = python3.pkgs.kivymd.overridePythonAttrs (old: {
    src = (
      old.src.override {
        rev = "0.104.1";
        hash = "sha256-qWiZ5bKw4gQtTvhe4w0Cadk17TbFFQWC0hvSFz9K4xA=";
      }
    );
  });
in
python3.pkgs.buildPythonApplication rec {
  pname = "katrain";
  version = "v1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanderland";
    repo = "katrain";
    tag = version;
    hash = "sha256-2DHamhxsOPKldRVxKHUoGKZn1Ao9l4D+TB4NkroixbA=";
  };

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  build-system = with python3.pkgs; [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      chardet
      docutils
      ffpyplayer
      kivy
      kivymd_0_104_1
      urllib3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ pygame ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ screeninfo ];

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

      You'll need to point the katrain config file at katago yourself.

      Alternatively, you can use the nixos module:
      programs.katrain = {
        enable = true;
        withXClip = true; # or withWlClipboard for wayland
      }
    '';
    mainProgram = "katrain";
    license = "https://github.com/sanderland/katrain/blob/master/LICENSE";
    maintainers = with maintainers; [ iofq ];
  };
}
