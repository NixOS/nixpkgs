{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  unstableGitUpdater,
}:

buildGoModule (
  finalAttrs:
  let
    ver = "0.2025.11";
    revDate = "2025-11-01";
    rev = "be0d4487871c196d0c47bb1b6ac7ce9252d424de";
    srcHash = "sha256-x7M7d8obnt8mpH1ZRev8c39PE5ZlgssgusGvrLaF/vg=";
    vendorHash = "sha256-TDvTZ0n324pNPAPMZMhWq0LdDUqFrzBXNVNdfMlxqeQ=";
    npmDepsHash = "sha256-4Ir4uq9Hg6Hwj21P/H7xWdVPzYrDrXiouEtjnLJj4Ko=";

  in
  {
    pname = "gomuks-web";
    version = "${ver}-unstable-${revDate}";

    inherit vendorHash;

    src = fetchFromGitHub {
      owner = "gomuks";
      repo = "gomuks";
      hash = srcHash;
      inherit rev;
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
    ];

    env = {
      npmRoot = "web";
      npmDeps = fetchNpmDeps {
        src = "${finalAttrs.src}/web";
        hash = npmDepsHash;
      };
    };

    postPatch = ''
      substituteInPlace ./web/build-wasm.sh \
        --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=v${ver}" \
        --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=${rev}"
    '';

    doCheck = false;

    tags = [ "goolm" ];

    ldflags = [
      "-X 'go.mau.fi/gomuks/version.Tag=v${ver}'"
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
