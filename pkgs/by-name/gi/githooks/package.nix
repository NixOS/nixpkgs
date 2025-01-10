{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  testers,
  makeWrapper,
  githooks,
}:
buildGoModule rec {
  pname = "githooks";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "gabyx";
    repo = "githooks";
    rev = "v${version}";
    hash = "sha256-pTSC8ruNiPzQO1C6j+G+WFX3pz/mWPukuWkKUSYdfHw=";
  };

  modRoot = "./githooks";
  vendorHash = "sha256-ZcDD4Z/thtyCvXg6GzzKC/FSbh700QEaqXU8FaZaZc4=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ git ];

  strictDeps = true;

  ldflags = [
    "-s" # Disable symbole table.
    "-w" # Disable DWARF generation.
  ];

  # We need to disable updates and other features:
  # That is done with tag `package_manager_enabled`.
  tags = [ "package_manager_enabled" ];

  checkFlags =
    let
      skippedTests = [
        "TestGithooksCompliesWithGit" # Needs internet to download all hooks documentation.
        "TestUpdateImages" # Needs docker/podman.
      ];
    in
    [
      "-v"
      "-skip"
      "(${builtins.concatStringsSep "|" skippedTests})"
    ];

  doCheck = true;

  # We need to generate some build files before building.
  postConfigure = ''
    GH_BUILD_VERSION="${version}" \
      GH_BUILD_TAG="v${version}" \
      go generate -mod=vendor ./...
  '';

  postInstall = ''
    # Rename executable to proper names.
    mv $out/bin/cli $out/bin/githooks-cli
    mv $out/bin/runner $out/bin/githooks-runner
    mv $out/bin/dialog $out/bin/githooks-dialog
  '';

  postFixup = ''
    wrapProgram "$out/bin/githooks-cli" --prefix PATH : ${lib.makeBinPath [ git ]}
    wrapProgram "$out/bin/githooks-runner" --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = githooks;
    command = "githooks-cli --version";
    inherit version;
  };

  meta = with lib; {
    description = "Git hooks manager with per-repo and shared Git hooks including version control";
    homepage = "https://github.com/gabyx/Githooks";
    license = licenses.mpl20;
    maintainers = with maintainers; [ gabyx ];
    mainProgram = "githooks-cli";
  };
}
