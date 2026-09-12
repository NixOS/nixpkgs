{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  rustc,
  graphviz,
  postgresql,
  sqlite,
  xdg-utils,
  makeBinaryWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sabiql";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "riii111";
    repo = "sabiql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QKc53tMxz9/+5fnDdBvxAj/CPB/UE4uWQ3Kh1haTyAk=";
  };

  cargoHash = "sha256-ujT547EFdBxHWY6l1DDrTnMGAek26p3csGouJEk1Mwo=";

  # Upstream use latest rust version need to patch use nixpkgs version
  postPatch = ''
    sed -i 's/rust-version\s*=\s*".*"/rust-version = "${rustc.version}"/' Cargo.toml
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    sqlite
  ];

  postInstall =
    let
      runtimePathDeps = [
        graphviz
        postgresql
        sqlite
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ xdg-utils ];
    in
    ''
      wrapProgram $out/bin/sabiql \
        --prefix PATH : ${lib.makeBinPath runtimePathDeps}
    '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Fast PostgreSQL TUI written in Rust. driver-less, vim-first, with ER diagrams. No database drivers, no setup, just psql";
    mainProgram = "sabiql";
    homepage = "https://github.com/riii111/sabiql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theeasternfurry ];
  };
})
