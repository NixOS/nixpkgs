{ lib, bundlerApp, ruby, makeWrapper, python3Packages }:

bundlerApp {
  inherit ruby;
  pname = "stack_master";
  gemdir = ./.;
  exes = [ "stack_master" ];

  # toString prevents the update script from being copied into the nix store
  passthru.updateScript = toString ./update;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/stack_master --prefix PATH : ${
      lib.makeBinPath [ python3Packages.cfn-lint ]
    }
  '';

  meta = with lib; {
    description     = "StackMaster is a CLI tool to manage CloudFormation stacks.";
    homepage        = "https://github.com/envato/stack_master";
    license         = licenses.mit;
    maintainers     = with maintainers; [
      frogamic
    ];
    mainProgram = "stack_master";
  };
}
