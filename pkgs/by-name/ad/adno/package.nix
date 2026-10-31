{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

buildNpmPackage (finalAttrs: {
  pname = "adno";
  version = "1.0.6";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "adnodev";
    repo = "adno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FO93b3uQb6eX/BDoFc3ueoqePKEGNi4+SxObeUQ0hjA=";
  };

  npmDepsHash = "sha256-5UOxzIWb2gU+YsvNOWC7SqZVWP2kYa+vzTNPdzBKNko=";

  postInstall = ''
    mkdir -p "$out/bin" "$out/share/adno"
    cp -r dist/. "$out/share/adno/"

    cat > "$out/bin/adno" <<'EOF'
    set -euo pipefail

    export PYTHONDONTWRITEBYTECODE=1

    host="''${ADNO_HOST-127.0.0.1}"
    port="''${ADNO_PORT-8080}"

    exec ${lib.getExe python3} -m http.server "$port" \
      --bind "$host" \
      --directory "${placeholder "out"}/share/adno" \
      "$@"
    EOF

    chmod +x "$out/bin/adno"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web application for viewing, editing and sharing narratives and pathways on static images and IIIF images";
    homepage = "https://github.com/adnodev/adno";
    changelog = "https://github.com/adnodev/adno/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "adno";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
