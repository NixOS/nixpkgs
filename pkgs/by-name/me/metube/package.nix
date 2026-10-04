{
  lib,
  fetchFromGitHub,
  python3Packages,
  stdenvNoCC,
  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_10,
  ffmpeg-full,
  aria2,
  curl,
  unzip,
  nixosTests,
}:
let
  pname = "metube";
  version = "2026.09.25";

  src = fetchFromGitHub {
    owner = "alexta69";
    repo = "metube";
    tag = version;
    hash = "sha256-RYSMYtauOnMVXThi4HQcww0N0dcp4OXcQga8mWCbSL4=";
  };

  metube-ui = stdenvNoCC.mkDerivation {
    pname = "${pname}-ui";
    inherit src version;
    __structuredAttrs = true;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    sourceRoot = "${src.name}/ui";

    pnpmDeps = fetchPnpmDeps {
      inherit (metube-ui)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-482KPJ8Ic5pt6Yw+mG+q3/xtmBZXhOW163DE/76eNwg=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/dist
      cp -r dist/metube $out/dist
      runHook postInstall
    '';
  };
in
python3Packages.buildPythonApplication {
  inherit pname src version;
  __structuredAttrs = true;

  pyproject = true;
  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [
    aiohttp
    python-socketio
    yt-dlp
    mutagen
    curl-cffi
    watchfiles
  ];

  postPatch = ''
    touch app/__init__.py
    substituteInPlace app/main.py --replace-fail "if __name__ == '__main__':" "def main():"
    find app -name "*.py" -print0 | while IFS= read -r -d "" file; do
      substituteInPlace "$file" \
        --replace "from ytdl import" "from .ytdl import" \
        --replace "from dl_formats import" "from .dl_formats import" \
        --replace "from state_store import" "from .state_store import" \
        --replace "from subscriptions import" "from .subscriptions import" \
        --replace "import bg_tasks" "from . import bg_tasks" \
        --replace "from music_metadata import" "from .music_metadata import" \
        --replace "from url_guard import" "from .url_guard import"
    done

    cat >> pyproject.toml << EOF
    [project.scripts]
    metube = "app.main:main"

    [build-system]
    requires = ["uv_build"]
    build-backend = "uv_build"

    [tool.uv.build-backend]
    module-root = "."
    module-name = "app"
    EOF
  '';

  postFixup = ''
    mkdir -p $out/share/ui
    cp -r ${metube-ui}/dist $out/share/ui
  '';

  makeWrapperArgs = [
    "--set"
    "BASE_DIR"
    "${placeholder "out"}/share"
    "--set"
    "METUBE_VERSION"
    "${version}"
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      ffmpeg-full
      aria2
      curl
      unzip
    ]}"
  ];

  passthru.tests.metube = nixosTests.metube;

  meta = {
    description = "Self-hosted video downloader for YouTube and other sites";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/alexta69/metube";
    changelog = "https://github.com/alexta69/metube/releases/tag/${version}";
    maintainers = with lib.maintainers; [ hunterwilkins2 ];
    mainProgram = "metube";
    platforms = with lib.platforms; darwin ++ linux;
  };
}
