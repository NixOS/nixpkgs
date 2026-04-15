{
  buildGoModule,
  lib,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "revive";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${finalAttrs.version}";
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-SfMI9qLk/L4Zh5kgqEO0QoqonBQTl5JCuickpe1Q3lU=" # For some reason there is a hash mismatch on darwin.
      else
        "sha256-38NFrKNkVp3hvv5/4bT2JR6mi5Pb7Atx/1xbx5HmOX4=";
  };

  vendorHash = "sha256-KxDWd+fd30eOttNEB6kQDxc2Lnf5Rj2zTCohjyfjMnU=";

  # Only build the revive package at the root.
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w" # Best practice for removing debugging information in a production environment.
    "-X github.com/mgechev/revive/cli.version=${finalAttrs.version}" # Necessary for the executable to be aware of its own version.
    "-X github.com/mgechev/revive/cli.builtBy=nix"
  ];

  meta = {
    description = "Fast, configurable, extensible, flexible, and beautiful linter for Go";
    longDescription = "Drop-in replacement for golint. Revive provides a framework for development of custom rules, and lets you define a strict preset for enhancing your development & code review processes";
    homepage = "https://revive.run";
    downloadPage = "https://github.com/mgechev/revive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "revive";
  };
})
