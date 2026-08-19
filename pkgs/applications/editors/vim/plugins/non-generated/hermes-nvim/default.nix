{
  lib,
  fetchzip,
  rustPlatform,
  runCommand,
  writeShellScript,
  stdenv,
  curl,
  cacert,
  jq,
  common-updater-scripts,
  nix-prefetch-scripts,
  pkg-config,
}:

let
  version = "0.12.1";

  src = fetchzip {
    url = "https://github.com/Ruddickmg/hermes.nvim/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-chPhu7e3LG28DAzkJRWEIG5tVnKXrF+ctc23ZwQc8o0=";
  };

  dejavuFont = fetchzip {
    url = "https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_2_37/dejavu-fonts-ttf-2.37.zip";
    hash = "sha256-JM75TClUBnQ7qKMHXbOD96ZoTxOhBFnsN5xH0QSafjc=";
    stripRoot = false;
  };

  agentSvgs = stdenv.mkDerivation {
    name = "hermes-agent-svgs";
    nativeBuildInputs = [
      curl
      cacert
      jq
    ];
    phases = [
      "buildPhase"
      "installPhase"
    ];
    buildPhase = ''
      mkdir -p "$out"
      jq -r '.agents[].icon | select(. != null)' \
        "${src}/src/acp/registry/registry.json" \
        | while read -r url; do
          curl -sfLo "$out/$(basename "$url")" "$url" \
            || echo "warning: failed $url" >&2
      done
    '';
    installPhase = "true";
    outputHashMode = "recursive";
    outputHash = "sha256-N8eyv3wcohj0l/giOmwzwy3drduhHhA/klFYqffmHQ0=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hermes-nvim";
  inherit version src;
  __structuredAttrs = true;

  cargoHash = "sha256-cKMurBrYpCv0F6AvAKycsCFbY1tl35WNgyBwh5T3oao=";

  cargoBuildFeatures = [ "with-icons" ];

  nativeBuildInputs = [ pkg-config ];

  env = {
    HERMES_FONT_PATH = "${dejavuFont}/dejavu-fonts-ttf-2.37/ttf/DejaVuSansMono.ttf";
    HERMES_ICONS_DIR = agentSvgs;
  };

  doCheck = false;

  forceShare = [
    "man"
    "info"
  ];

  postInstall = ''
    cp -r lua $out/
    cp -r plugin $out/
    cp -r doc $out/ 2>/dev/null || true
  '';

  passthru = {
    vimPlugin = true;
    inherit agentSvgs dejavuFont;

    tests.basic =
      runCommand "hermes-nvim-test-basic" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          test -f "${finalAttrs.finalPackage}/lua/hermes/init.lua"
          test -f "${finalAttrs.finalPackage}/plugin/hermes.lua"
          test -f "${finalAttrs.finalPackage}/doc/hermes.txt"
          ls "${finalAttrs.finalPackage}/lib/" | grep -q 'libhermes'
          mkdir -p $out
        '';

    updateScript = writeShellScript "update-hermes-nvim" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
          nix-prefetch-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/Ruddickmg/hermes.nvim/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "Version has not changed, skipping update."
          exit 0
      fi
      update-source-version "vimPlugins.hermes-nvim" "$NEW_VERSION" --ignore-same-version

      NEW_SVG_HASH=$(
        nix-build --no-out-link -E '
          let
            pkgs = import ./. {};
            pkg = pkgs.vimPlugins.hermes-nvim;
          in pkg.passthru.agentSvgs.overrideAttrs (_: {
            outputHash = "";
            outputHashAlgo = "sha256";
          })
        ' 2>&1 | grep -oP 'got: \K.*'
      ) || true
      if [[ -n "$NEW_SVG_HASH" ]]; then
        sed -i "s|outputHash = \"[^\"]*\";|outputHash = \"$NEW_SVG_HASH\";|" \
          "pkgs/applications/editors/vim/plugins/non-generated/hermes-nvim/default.nix"
      fi
    '';
  };

  meta = {
    description = "ACP (Agent Client Protocol) client for Neovim";
    homepage = "https://github.com/Ruddickmg/hermes.nvim";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Ruddickmg ];
    platforms = lib.platforms.unix;
  };
})
