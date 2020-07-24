# Dotnet

## Local Development Workflow

For local development, it's recommended to use nix-shell to create a dotnet environment:

```
# shell.nix
with import <nixpkgs> {};

mkShell {
  name = "dotnet-env";
  buildInputs = [
    dotnet-sdk_3
  ];
}
```

### Using many sdks in a workflow

It's very likely that more than one sdk will be needed on a given project. Dotnet provides several different frameworks (E.g dotnetcore, aspnetcore, etc.) as well as many versions for a given framework. Normally, dotnet is able to fetch a framework and install it relative to the executable. However, this would mean writing to the nix store in nixpkgs, which is read-only. To support the many-sdk use case, one can compose an environment using `dotnetCorePackages.combinePackages`:

```
with import <nixpkgs> {};

mkShell {
  name = "dotnet-env";
  buildInputs = [
    (with dotnetCorePackages; combinePackages [
      sdk_3_1
      sdk_3_0
      sdk_2_1
    ])
  ];
}
```

This will produce a dotnet installation that has the dotnet 3.1, 3.0, and 2.1 sdk. The first sdk listed will have it's cli utility present in the resulting environment. Example info output:

```
$ dotnet --info
.NET Core SDK (reflecting any global.json):
 Version:   3.1.101
 Commit:    b377529961

...

.NET Core SDKs installed:
  2.1.803 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/sdk]
  3.0.102 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/sdk]
  3.1.101 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/sdk]

.NET Core runtimes installed:
  Microsoft.AspNetCore.All 2.1.15 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.AspNetCore.All]
  Microsoft.AspNetCore.App 2.1.15 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.AspNetCore.App]
  Microsoft.AspNetCore.App 3.0.2 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.AspNetCore.App]
  Microsoft.AspNetCore.App 3.1.1 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 2.1.15 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 3.0.2 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 3.1.1 [/nix/store/iiv98i2jdi226dgh4jzkkj2ww7f8jgpd-dotnet-core-combined/shared/Microsoft.NETCore.App]
```

## dotnet-sdk vs dotnetCorePackages.sdk

The `dotnetCorePackages.sdk_X_Y` is preferred over the old dotnet-sdk as both major and minor version are very important for a dotnet environment. If a given minor version isn't present (or was changed), then this will likely break your ability to build a project.

## dotnetCorePackages.sdk vs dotnetCorePackages.netcore vs dotnetCorePackages.aspnetcore

The `dotnetCorePackages.sdk` contains both a runtime and the full sdk of a given version. The `netcore` and `aspnetcore` packages are meant to serve as minimal runtimes to deploy alongside already built applications.

## Packaging a Dotnet Application

Ideally, we would like to build against the sdk, then only have the dotnet runtime available in the runtime closure.

TODO: Create closure-friendly way to package dotnet applications
