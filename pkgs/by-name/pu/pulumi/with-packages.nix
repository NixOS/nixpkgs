{
  lib,
  runCommand,
  pulumi,
  pulumiPackages,
  makeBinaryWrapper,
}:
f:
# Note that Pulumi prints a warning for “ambient” plugins (i.e. from PATH). E.g.
#   warning: using pulumi-resource-* from $PATH at /nix/store/*
# See also https://github.com/pulumi/pulumi/issues/14525
#
# We can install packages alongside pulumi executable, but that would only
# suppress the warning for packages that are bundled with the official
# distribution. Refer to the implementation of workspace.IsPluginBundled:
# https://pkg.go.dev/github.com/pulumi/pulumi/sdk/v3@v3.150.0/go/common/workspace#IsPluginBundled
# https://github.com/pulumi/pulumi/blob/v3.150.0/sdk/go/common/workspace/plugins.go#L2202-L2210
runCommand "pulumi-with-packages"
  {
    inherit pulumi;
    makeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      (lib.makeBinPath (f pulumiPackages))
    ];
    __structuredAttrs = true;
    nativeBuildInputs = [ makeBinaryWrapper ];
    meta.mainProgram = "pulumi";
  }
  ''
    mkdir -p "$out/bin"
    ln -s -t "$out" "$pulumi/share"
    makeWrapper "$pulumi/bin/pulumi" "$out/bin/pulumi" "''${makeWrapperArgs[@]}"
  ''
