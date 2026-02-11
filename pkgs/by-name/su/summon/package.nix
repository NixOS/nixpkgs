{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "summon";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zPzRsfNN75AZ1qsL/VZUkFxzt3blp8eQPXQsMmis3Cs=";
  };

  vendorHash = "sha256-xD9wv5XYjOWykG4sTrovJH+E6HrX0N7zxfrrFeF6j4Q=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  meta = {
    description = "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quentini ];
  };
})
