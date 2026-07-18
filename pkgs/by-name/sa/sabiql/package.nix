{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  rustc,
  graphviz,
  postgresql,
  xdg-utils,
  makeBinaryWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sabiql";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "riii111";
    repo = "sabiql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fm9AINbCoazT2OHPJUO7YHpLt1KpQ8jDfXAkX3Karl0=";
  };

  cargoHash = "sha256-915W5zpavggfPN7artvgxkErWsx9eZ6953RX/eLQagg=";

  # Upstream use latest rust version need to patch use nixpkgs version
  postPatch = ''
    sed -i 's/rust-version\s*=\s*".*"/rust-version = "${rustc.version}"/' Cargo.toml
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall =
    let
      runtimePathDeps = [
        graphviz
        postgresql
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
