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
  version = "26.06";

  src = fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    tag = "v0.${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}.0";
    hash = "sha256-Q4hu3bcB16iuqASZvlv7nDvxj8CFX66qWp6DHIUTmh4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UH/T3eqFy0KrG/ouEzifJeWXXwe5cUPYG7DpIO0GsYc=";

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
      hash = "sha256-RiOes+tmAxhA9IkyA6yWQXTjjXyZg2Z8FmPTgcmCg/g=";
    };
  };

  postPatch = ''
    # required until libheif gets bumped
    substituteInPlace ./go.mod \
      --replace-fail 'github.com/strukturag/libheif v1.23.0' 'github.com/strukturag/libheif v1.21.2'

    substituteInPlace ./go.sum \
      --replace-fail 'github.com/strukturag/libheif v1.23.0 h1:G9Fjf/b8dvTgLIk148tUKp7Z7rgu88FC+Mc8o92U98k=' 'github.com/strukturag/libheif v1.21.2 h1:YFD3crf+d33cFVQh3aTkkVGwJFyWpfqVT4XhzHWU6mA=' \
      --replace-fail 'github.com/strukturag/libheif v1.23.0/go.mod h1:E/PNRlmVtrtj9j2AvBZlrO4dsBDu6KfwDZn7X1Ce8Ks=' 'github.com/strukturag/libheif v1.21.2/go.mod h1:E/PNRlmVtrtj9j2AvBZlrO4dsBDu6KfwDZn7X1Ce8Ks='


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
