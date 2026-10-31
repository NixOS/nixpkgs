{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssh,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosh";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "cosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yx+6tuaASCUrUcnq++JvkufH1DZB1gwnVtS2YVfEOuM=";
  };

  cargoHash = "sha256-UeqgD7gQXllkIUXKTVtXi/NTBhRNNkHSesFECR+vbrs=";

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

  # Remove hardcoded paths
  postPatch = ''
    substituteInPlace lib/ssh-agent.ch \
      --replace-fail "/usr/bin/ssh-add" "${lib.getBin openssh}/bin/ssh-add" \
      --replace-fail "/usr/bin/ssh-agent" "${lib.getBin openssh}/bin/ssh-agent"
  '';

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

  doCheck = true;

  checkFlags = [
    "--skip=append_redirect_test"
    "--skip=no_zombies"
  ];

  postInstall = ''
    make install prefix="$out"
    mkdir -p "$doc/share/cosh"
    cp -Tr doc/ "$doc/share/cosh"
  '';

  meta = {
    description = "Concatenative command-line shell";
    # VM’s parallelism requires epoll
    platforms = lib.platforms.linux;
    mainProgram = "cosh";
    homepage = "https://github.com/tomhrr/cosh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
