{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  unstableGitUpdater,
  applyPatches,
  fetchpatch,
  pkg-config,
  libheif,
}:

buildGoModule (
  finalAttrs:
  let
    rev = "5b3942a75ccf3dcf244d0e7e5f8e02896b86bbda";

  in
  {
    pname = "gomuks-web";
    version = "0.2602.0";

    proxyVendor = true;
    vendorHash = "sha256-VjcKxZ9hYxmha5KCuJ5ms7eclAOlsNTWZMmpNhmzX8U=";

    src = applyPatches {
      src = fetchFromGitHub {
        owner = "gomuks";
        repo = "gomuks";
        inherit rev;
        hash = "sha256-IpxTlirZCXjUHaZbvDew3WWlt0kuKffJQ4BFix2iQjg=";
      };
      patches = [
        # required patch to use libheif instead of goheif which won't build
        (fetchpatch {
          url = "https://github.com/gomuks/gomuks/commit/c794a3e9034d76dc1a8c1598f1ff957ecda9e22d.patch";
          sha256 = "sha256-QyPX2bLuGHqdv/17Pf+N/f1gq/tAbSQKVagN+6S3rJ8=";
        })
      ];
    };

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
        hash = "sha256-ob85fZDC3Qcos53MGvf+c1eGEO/SvfUTdnjA3T/y6/A=";
      };
    };

    postPatch = ''
      substituteInPlace ./web/build-wasm.sh \
        --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=v${finalAttrs.version}" \
        --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=${rev}"
    '';

    doCheck = false;

    tags = [
      "goolm"
      "libheif"
    ];

    ldflags = [
      "-X 'go.mau.fi/gomuks/version.Tag=v${finalAttrs.version}'"
      "-X 'go.mau.fi/gomuks/version.Commit=${rev}'"
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

    passthru.updateScript = {
      inherit (finalAttrs) frontend;
      updateScript = unstableGitUpdater {
        branch = "main";
      };
    };

    meta = {
      mainProgram = "gomuks-web";
      description = "Matrix client written in Go";
      homepage = "https://github.com/tulir/gomuks";
      license = lib.licenses.agpl3Only;
      maintainers = [ lib.maintainers.zaphyra ];
      platforms = lib.platforms.unix;
    };
  }
)
