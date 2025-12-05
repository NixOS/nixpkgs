{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  ffmpeg-headless,
  makeWrapper,
  nixosTests,
  nodejs,
  npmHooks,
  fetchNpmDeps,

  # For the update script
  coreutils,
  curl,
  nix-prefetch-git,
  prefetch-npm-deps,
  jq,
  writeShellScript,
}:
let
  srcJson = lib.importJSON ./src.json;
  src = fetchFromGitHub {
    owner = "azlux";
    repo = "botamusique";
    inherit (srcJson) rev sha256;
  };

  # Python needed to instantiate the html templates
  buildPython = python3Packages.python.withPackages (ps: [ ps.jinja2 ]);
in

stdenv.mkDerivation rec {
  pname = "botamusique";
  version = srcJson.version;

  inherit src;

  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = srcJson.npmDepsHash;
  };

  npmRoot = "web";

  patches = [
    # botamusique by default resolves relative state paths by first checking
    # whether it exists in the working directory, then falls back to using the
    # installation directory. With Nix however, the installation directory is
    # not writable, so that won't work. So we change this so that it uses
    # relative paths unconditionally, whether they exist or not.
    ./unconditional-relative-state-paths.patch

    # We can't update the package at runtime with NixOS, so this patch makes
    # the !update command mention that
    ./no-runtime-update.patch

    # Fix passing of invalid "git" version into version.parse, which results
    # in an InvalidVersion exception. The upstream fix is insufficient, so
    # we carry the correct patch downstream for now.
    ./catch-invalid-versions.patch
  ];

  postPatch = ''
    # However, the function that's patched above is also used for
    # configuration.default.ini, which is in the installation directory
    # after all. So we need to counter-patch it here so it can find it absolutely
    substituteInPlace mumbleBot.py \
      --replace "configuration.default.ini" "$out/share/botamusique/configuration.default.ini" \
      --replace "version = 'git'" "version = '${version}'"
  '';

  NODE_OPTIONS = "--openssl-legacy-provider";

  nativeBuildInputs = [
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    python3Packages.wrapPython
  ];

  pythonPath = with python3Packages; [
    audioop-lts
    flask
    magic
    mutagen
    packaging
    pillow
    pymumble
    pyradios
    requests
    yt-dlp
  ];

  buildPhase = ''
    runHook preBuild

    # Generates artifacts in ./static
    (
      cd web
      npm run build
    )

    # Fills out http templates
    ${buildPython}/bin/python scripts/translate_templates.py --lang-dir lang/ --template-dir templates/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp -r . $out/share/botamusique
    chmod +x $out/share/botamusique/mumbleBot.py
    wrapPythonProgramsIn $out/share/botamusique "$out $pythonPath"

    # Convenience binary and wrap with ffmpeg dependency
    makeWrapper $out/share/botamusique/mumbleBot.py $out/bin/botamusique \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "botamusique-updater" ''
    export PATH=${
      lib.makeBinPath [
        coreutils
        curl
        nix-prefetch-git
        jq
        prefetch-npm-deps
      ]
    }
    set -ex

    OWNER=azlux
    REPO=botamusique
    VERSION="$(curl https://api.github.com/repos/$OWNER/$REPO/releases/latest | jq -r '.tag_name')"

    nix-prefetch-git --rev "$VERSION" --url https://github.com/$OWNER/$REPO | \
      jq > "${toString ./src.json}" \
        --arg version "$VERSION" \
        '.version |= $version'
    path="$(jq '.path' -r < "${toString ./src.json}")"

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' exit

    npmHash="$(prefetch-npm-deps $path/web/package-lock.json)"
    jq '. + { npmDepsHash: "'"$npmHash"'" }' < "${toString ./src.json}" > "$tmp/src.json"
    mv "$tmp/src.json" "${toString ./src.json}"
  '';

  passthru.tests = {
    inherit (nixosTests) botamusique;
  };

  meta = with lib; {
    description = "Bot to play youtube / soundcloud / radio / local music on Mumble";
    homepage = "https://github.com/azlux/botamusique";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "botamusique";
  };
}
