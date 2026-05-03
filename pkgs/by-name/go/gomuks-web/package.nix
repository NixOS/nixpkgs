{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  pkg-config,
  libheif,
}:

buildGoModule (finalAttrs: {
  pname = "gomuks-web";
  version = "26.04";

  src = fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";
    hash = "sha256-IysL++H3ncAU1xqNWKy2Z9RKkF1hriVmIDdQu0SkDbQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Ev6nmmOzLPjXp8XYj+7MRPElfGAv8fUcXJ5fXP8LCvs=";

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
      hash = "sha256-NeQzz2+Vdi1OtVN7ZF8I33nFCO7OpccD1AjpPl7tML4=";
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

  passthru.updateScript = ./update.sh;

  meta = {
    mainProgram = "gomuks-web";
    description = "Matrix client written in Go";
    homepage = "https://github.com/tulir/gomuks";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.zaphyra ];
    platforms = lib.platforms.unix;
  };
})
