{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  callPackage,
  runCommand,
}:

buildGoModule (finalAttrs: {
  pname = "packer";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2XtuVP4CDJjpylLsSClukDdSaosn45hw46SceqoNESg=";
  };

  vendorHash = "sha256-S42vmdO5rHz+DNxp6cXE/vJ4FMNx5lnCV2tnn4agkrk=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  passthru =
    let
      pluginScope = callPackage ./plugins.nix { };
    in
    {
      plugins = lib.filterAttrs (_: lib.isDerivation) pluginScope;

      withPlugins =
        f:
        (callPackage ./with-plugins.nix {
          packer = finalAttrs.finalPackage;
          packerPlugins = pluginScope;
        })
          { selector = f; };

      tests.withPlugins =
        let
          packer-with-docker = finalAttrs.passthru.withPlugins (ps: [ ps.docker ]);
        in
        runCommand "packer-test-with-plugins"
          {
            nativeBuildInputs = [ packer-with-docker ];
          }
          ''
            packer plugins installed > output.txt
            cat output.txt

            expected_path="${finalAttrs.passthru.plugins.docker.pluginPath}"
            if ! grep -q "$expected_path" output.txt; then
              echo "ERROR: Expected plugin path not found in 'packer plugins installed' output"
              echo "Expected: $expected_path"
              echo "Got:"
              cat output.txt
              exit 1
            fi

            touch $out
          '';
    };

  meta = {
    description = "Tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage = "https://www.packer.io";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      zimbatm
      ma27
      techknowlogick
      qjoly
      jlesquembre
    ];
    changelog = "https://github.com/hashicorp/packer/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
