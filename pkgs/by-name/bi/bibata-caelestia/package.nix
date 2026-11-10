{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  gobject-introspection,
  librsvg,
  hyprcursor,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.pygobject3
    ps.pycairo
    ps.pillow
  ]);
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-caelestia";
  version = "0-unstable-2026-09-05";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dim-ghub";
    repo = "Bibata-Caelestia";
    rev = "8b808e86b617ecc94ae500b1c32b804cc11dd57f";
    hash = "sha256-Mjiwo1M28ghRmLDQzJc83irc9RDI/lYIh9A81V8M8qI=";
  };

  nativeBuildInputs = [
    makeWrapper
    gobject-introspection
    hyprcursor
    pythonEnv
  ];

  buildInputs = [
    librsvg
  ];

  postPatch = ''
    substituteInPlace builder.py \
      --replace-fail 'search_dirs.append(Path(__file__).parent / "templates")' \
                     'search_dirs.append(Path(__file__).parent / "templates"); search_dirs.append(Path(os.environ.get("BIBATA_TEMPLATES_DIR", Path(__file__).resolve().parent.parent / "share/bibata-caelestia/templates")))'
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR"
    python3 builder.py build --dest "$TMPDIR/Bibata-Caelestia" --size 24

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 "$out/share/icons"
    cp -rf "$TMPDIR/Bibata-Caelestia" "$out/share/icons/"

    install -dm 0755 "$out/share/bibata-caelestia/templates"
    cp -rf templates/*.svg "$out/share/bibata-caelestia/templates/"

    install -Dm 0755 builder.py "$out/bin/bibata-caelestia-builder"
    wrapProgram "$out/bin/bibata-caelestia-builder" \
      --prefix PATH : "${
        lib.makeBinPath [
          hyprcursor
          pythonEnv
        ]
      }" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [ librsvg ]}" \
      --set BIBATA_TEMPLATES_DIR "$out/share/bibata-caelestia/templates"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Dynamic Material You themeable cursor theme based on Bibata Modern Classic for Caelestia";
    homepage = "https://github.com/dim-ghub/Bibata-Caelestia";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "bibata-caelestia-builder";
    platforms = lib.platforms.linux;
  };
})
