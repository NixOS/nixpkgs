{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosh";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "cosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5BZgSTKb2Mj20JSyYEYUAgCc6cuImI0Yw0BGx8rSRp0=";
  };

  cargoHash = "sha256-TkplRyPkJLcj4ynGB1BfOHdpk2U+MkHV6ctVsLO5Nuw=";

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  outputs = [
    "out"
    "doc"
  ];

  # Makefile expects the binary at target/release/cosh, but the already-ran
  # cargoBuildHook builds with --target, so the binary ends up @
  # target/<triple>/release/cosh; symlinking to avoid a second full `cargo
  # build` (which would lack cargoBuildHook flags). However, running the
  # Makefile means we don’t need to manually specify or compile *.ch
  # files — which allows this package definition to just build upstream’s
  # expected setup.
  postBuild = ''
    cosh_bin=$(find target -name cosh -type f -executable | head -n 1)
    mkdir -p "target/release"
    ln -sf "$PWD/$cosh_bin" target/release/cosh
    make all prefix="$out"
  '';

  # Tests require:
  # • /etc/resolv.conf (VM::new panics without)
  # • PostgreSQL/MySQL services for some DB tests
  doCheck = false;

  postInstall = ''
    make install prefix="$out"
    mkdir -p "$doc/share/cosh"
    cp -Tr doc/ "$doc/share/cosh"
  '';

  meta = {
    description = "Concatenative command-line shell";
    mainProgram = "cosh";
    homepage = "https://github.com/tomhrr/cosh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
