{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  pkg-config,
  libheif,

  writeShellApplication,
  _experimental-update-script-combinators,
  nix-update-script,
  nix,
  jq,
}:

buildGoModule (finalAttrs: {
  pname = "gomuks-web";
  version = "26.07";

  src = fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";
    hash = "sha256-OgcmRBuVFTPzAVgNVDUZcfdgxHi4mtUcbmfTRPx/f9M=";
  };

  proxyVendor = true;
  vendorHash = "sha256-wNscq9FDJb9+WqKCBZ9YD+EQ/Sc2PAznunKP6hrs+Ms=";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    libheif
  ];

  env = {
    npmRoot = "web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/web";
      hash = "sha256-C+zEMI2wmO3EvefpswTk9Tq3AV1Acfi+w3oO5WpxLIQ=";
    };
  };

  postPatch = ''
    substituteInPlace ./web/build-wasm.sh \
      --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=${finalAttrs.src.tag}" \
      --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=unknown"
  '';

  doCheck = false;

  tags = [
    "goolm"
    "libheif"
    "sqlite_fts5"
  ];

  ldflags = [
    "-X 'go.mau.fi/gomuks/version.Tag=${finalAttrs.src.tag}'"
    "-X 'go.mau.fi/gomuks/version.Commit=unknown'"
    "-X \"go.mau.fi/gomuks/version.BuildTime=$(date -Iseconds)\""
    "-X \"maunium.net/go/mautrix.GoModVersion=$(cat go.mod | grep 'maunium.net/go/mautrix ' | head -n1 | awk '{ print $2 })\""
  ];

  subPackages = [
    "cmd/gomuks"
    "cmd/gomuks-terminal"
    "cmd/archivemuks"
  ];

  preBuild = ''
    CGO_ENABLED=0 go generate ./web
  '';

  postInstall = ''
    mv $out/bin/gomuks $out/bin/gomuks-web
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    ./update.sh

    # Update gomuks-desktop
    (lib.getExe (writeShellApplication {
      name = "gomuks-desktop-electron-updater";
      runtimeInputs = [
        nix
        jq
      ];
      runtimeEnv = {
        PNAME = finalAttrs.pname; # we actually don't care as `-desktop` inherits the source
        PKG_DIR = toString ./.; # nixpkgs-vet complains if we refer to a file outside this dir
      };
      text = ''
        set -euo pipefail

        new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)/desktop"
        new_electron_major="$(jq -r '.devDependencies.electron' "$new_src/package.json" | cut -d. -f1)"

        sed -i -E "s/electron_[0-9]+/electron_$new_electron_major/g" "$PKG_DIR/../gomuks-desktop/package.nix"
      '';
    }))
    (nix-update-script {
      # Updates npmDepsHash
      attrPath = "gomuks-desktop";
      extraArgs = [
        "--no-src"
        "--version=skip"
      ];
    })
  ];

  meta = {
    mainProgram = "gomuks-web";
    description = "Matrix client written in Go";
    homepage = "https://github.com/tulir/gomuks";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      zaphyra

      # For the gomuks-desktop update script
      logn
      xaltsc
    ];
    platforms = lib.platforms.unix;
  };
})
