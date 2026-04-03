{
  buildDotnetModule,
  copyDesktopItems,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  makeWrapper,
  python3,
  stdenv,
}:
let
  name = "crosspatch";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "NickPlayzGITHUB";
    repo = "CrossPatch";
    hash = "sha256-Ux+tLP5Hv8ecnuITMqLiuX0YtF2ENZ7ezi2gNKfuNcM=";
    tag = version;
  };

  python = python3.withPackages (ps: [
    ps.patool
    ps.py7zr
    ps.pyqtdarktheme
    ps.pyside6
    ps.rarfile
    ps.requests
  ]);

  parser = buildDotnetModule rec {
    inherit version src;
    pname = "crosspatch-parser";
    sourceRoot = "${src.name}/tools/CrossPatchParser";
    nugetDeps = ./dependencies.json;
    meta.mainProgram = "CrossPatchParser";
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = name;
  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ copyDesktopItems ];

  postPatch = ''
    mkdir "$out"
    cp -r "$src/src" "$out/src"
    substituteInPlace "$out/src/PakInspector.py" --replace 'possible_paths = _possible_parser_paths()' 'possible_paths = ["${lib.getExe parser}"]'
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p "$out/bin"
    makeWrapper "${lib.getExe python}" "$out/bin/crosspatch" --add-flag "$out/src/CrossPatch.py"
    runHook postBuild
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    inherit name;
    desktopName = "CrossPatch";
    exec = "crosspatch";
  });

  meta = {
    mainProgram = "crosspatch";
    description = "A mod Manager for Sonic Racing: CrossWorlds";
    homepage = "https://github.com/NickPlayzGITHUB/CrossPatch";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toodeluna ];
  };
}
