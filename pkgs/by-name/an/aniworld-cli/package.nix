{
  fetchFromGitHub,
  makeWrapper,
  lib,
  python3,
  mpv,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aniworld-cli";
  version = "0.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dxmoc";
    repo = "aniworld-cli";
    tag = "v${version}";
    hash = "sha256-rIMZeomEe/kRvC07tbCX3cKAoIobFZaWgeG4HietlYA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    beautifulsoup4
    questionary
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/aniworld-cli \
      --suffix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  pythonImportsCheck = [ "aniworld_cli" ];

  meta = {
    homepage = "https://github.com/dxmoc/aniworld-cli";
    description = "Pure-Python streaming-only CLI for aniworld.to, playback via mpv";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      v3rm1n0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "aniworld-cli";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
}
