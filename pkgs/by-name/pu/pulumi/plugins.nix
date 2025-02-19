{ callPackage }:
let
  mkPulumiPackage = callPackage ./extra/mk-pulumi-package.nix { };
  callPackage' = p: args: callPackage p (args // { inherit mkPulumiPackage; });
in
{
  pulumi-aws-native = callPackage' ./plugins/pulumi-aws-native.nix { };
  pulumi-azure-native = callPackage' ./plugins/pulumi-azure-native.nix { };
  pulumi-command = callPackage' ./plugins/pulumi-command.nix { };
  pulumi-hcloud = callPackage' ./plugins/pulumi-hcloud.nix { };
  pulumi-language-go = callPackage ./plugins/pulumi-language-go.nix { };
  pulumi-language-nodejs = callPackage ./plugins/pulumi-language-nodejs.nix { };
  pulumi-language-python = callPackage ./plugins/pulumi-language-python.nix { };
  pulumi-random = callPackage' ./plugins/pulumi-random.nix { };
  pulumi-yandex-unofficial = callPackage' ./plugins/pulumi-yandex-unofficial.nix { };
}
