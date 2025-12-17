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
    rev = "9de4eb7fe537b6a8c40977ea99b7e9a5816d62f4";
    srcHash = "sha256-CC4CNizoi91dfyoNsaIqxAuBB62j8JB076QEIpncky0=";
    vendorHash = "sha256-opx/NlWgLk1rUHbLJ6Vp2dMLheBdOtL+NgCmWE89H9g=";
    npmDepsHash = "sha256-mYeT07XfdAFYjwD4EfLRAgCZY0S8zj68p8UNGBpcpmQ=";

  in
  {
    pname = "gomuks-web";
    version = "0.2512.0";

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
        --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=v${finalAttrs.version}" \
        --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=${rev}"
    '';

    doCheck = false;

    tags = [ "goolm" ];

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
