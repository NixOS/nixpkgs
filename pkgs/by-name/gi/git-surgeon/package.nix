{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  git,
  nix-update-script,
  python3,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-surgeon";
  version = "0.1.17";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "raine";
    repo = "git-surgeon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SeXHYZwhwvkYxFHW694Cp1VKKeehxgOdfKqShuPI7M4=";
  };

  cargoHash = "sha256-PbhASsdDxmVcIzV+oHIbpX70zjSeNvkwGcbhQRi88rE=";

  nativeCheckInputs = [
    git
    (python3.withPackages (p: [
      p.pytest
      p.pytest-xdist
    ]))
    writableTmpDirAsHomeHook
  ];

  postCheck = ''
    export GIT_CONFIG_GLOBAL=$(mktemp)
    git config --global init.defaultBranch main
    mkdir -p target/debug
    ln -s "$(pwd)/target/${stdenv.hostPlatform.rust.rustcTarget}/release/git-surgeon" target/debug/git-surgeon
    pytest tests/ -x
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git primitives for autonomous coding agents";
    homepage = "https://github.com/raine/git-surgeon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jhol ];
    mainProgram = "git-surgeon";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
