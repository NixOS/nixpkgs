{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  withUI ? true,
}:

buildGoModule (finalAttrs: {
  pname = "exatorrent";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "varbhat";
    repo = "exatorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FvL3ekpj1HwARgY3vj0xAwCgDBa97OqtFFY4rSBKr50=";
  };

  nativeBuildInputs = lib.optionals withUI [
    npmHooks.npmConfigHook
    nodejs
  ];

  npmRoot = "internal/web";

  npmDeps =
    if withUI then
      fetchNpmDeps {
        name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
        inherit (finalAttrs) src;
        sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
        hash = "sha256-eNrBKTW4KlLNf/Y9NTvGt5r28MG7SLGzUi+p9mOyrmI=";
      }
    else
      null;

  preBuild = lib.optionalString withUI ''
    pushd "$npmRoot"
    npm run build
    popd
  '';

  # I dislike the fact that buildGoModule's fetcher FOD automatically inherits some attrs from the non-FOD part
  overrideModAttrs = prev: {
    nativeBuildInputs = lib.filter (e: e != npmHooks.npmConfigHook) prev.nativeBuildInputs;
    preBuild = "";
  };

  vendorHash = "sha256-fE+GVQ2HAfElO1UDmDMeu2ca7t5yNs83CXhqgT0t1Js=";

  tags = lib.optionals (!withUI) [ "noui" ];

  ldflags = [
    "-s"
    "-w"
  ]
  ++ lib.optionals stdenv.hostPlatform.isGnu [
    # upstream also tries to compile statically if possible
    "-extldflags '-static'"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isGnu [
    stdenv.cc.libc.static
  ];

  meta = {
    changelog = "https://github.com/varbhat/exatorrent/releases/tag/${finalAttrs.src.tag}";
    description = "Self-hostable, easy-to-use, lightweight, and feature-rich torrent client written in Go";
    homepage = "https://github.com/varbhat/exatorrent/";
    license = lib.licenses.gpl3Only;
    mainProgram = "exatorrent";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
