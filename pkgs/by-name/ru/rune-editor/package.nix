{
  lib,
  buildGo127Module,
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
buildGo127Module (finalAttrs: {
  pname = "rune-editor";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "unstablebuild";
    repo = "rune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q0tlnScblp17/ZL+SwRELYlkk3JKl8J/E06ncq+F06g=";
  };

  vendorHash = "sha256-NJSVFM76zqZ77d3uv+asKc6cJMd87skoxc1Mnp17Sew=";

  postPatch = ''
    substituteInPlace deploy/rune-linux/rune.desktop --replace-fail 'Exec=rune' "${placeholder "out"}/bin/rune"
  '';

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

    install -D ./bin/rune -t $out/bin
    wrapProgram $out/bin/rune --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

    install -Dm644 deploy/rune-linux/rune.desktop -t $out/share/applications

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
