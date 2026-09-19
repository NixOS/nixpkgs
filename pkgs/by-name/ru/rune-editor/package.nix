{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libGL,
  wayland,
  libxkbcommon,
  libx11,
  libxrandr,
  libxcursor,
  libxinerama,
  libxi,
  libxxf86vm,
  pkg-config,
  makeBinaryWrapper,
  nix-update-script,
}:
let
  # vendored go-tree-sitter links against a tree-sitter version older than the one in Nixpkgs
  tree-sitter-src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    tag = "v0.25.1";
    hash = "sha256-xnUhiIeRxD4ZKMUQ6pNEetDqiFqiJsa57BRM2zqNFro=";
  };
in
buildGoModule (finalAttrs: {
  pname = "rune-editor";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "unstablebuild";
    repo = "rune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YFRlQ3XZKi04mFP96W0sinzPzSI3F3J8vMMdFvBTx0c=";
  };

  vendorHash = "sha256-E/stKT0tCbuKiZ2If6AT2abB5KQ09+9D2f0aSsXBGCk=";

  preBuild = ''
    export CGO_CFLAGS="$CGO_CFLAGS -I${tree-sitter-src}/lib/src -I${tree-sitter-src}/lib/include"
  '';

  buildPhase =
    let
      commonLdFlags = lib.concatMapStringsSep " " (f: "-X ${f}") [
        "unstable.build/rune/internal/debug.Tag=v${finalAttrs.version}"
        "unstable.build/rune/internal/debug.Commit=Nixpkgs"
        "unstable.build/rune/internal/debug.BuildDate=$(date -u -d \"@$SOURCE_DATE_EPOCH\" +%Y-%m-%dT%H:%M:%SZ)"
      ];
    in
    ''
      runHook preBuild

      make -e rune COMMON_LDFLAGS="${commonLdFlags}"

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    install -D ./bin/rune $out/bin/rune
    wrapProgram $out/bin/rune --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

    runHook postInstall
  '';

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    libGL
    wayland
    libxkbcommon
    libx11
    libxrandr
    libxcursor
    libxinerama
    libxi
    libxxf86vm
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The development environment for pros";
    homepage = "https://github.com/unstablebuild/rune";
    changelog = "https://github.com/unstablebuild/rune/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ higherorderlogic ];
    mainProgram = "rune";
  };
})
