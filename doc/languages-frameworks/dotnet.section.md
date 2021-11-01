# Dotnet {#dotnet}

## Local Development Workflow {#local-development-workflow}

For local development, it's recommended to use nix-shell to create a dotnet environment:

```nix
# shell.nix
with import <nixpkgs> {};

mkShell {
  name = "dotnet-env";
  packages = [
    dotnet-sdk_3
  ];
}
```

### Using many sdks in a workflow {#using-many-sdks-in-a-workflow}

It's very likely that more than one sdk will be needed on a given project. Dotnet provides several different frameworks (E.g dotnetcore, aspnetcore, etc.) as well as many versions for a given framework. Normally, dotnet is able to fetch a framework and install it relative to the executable. However, this would mean writing to the nix store in nixpkgs, which is read-only. To support the many-sdk use case, one can compose an environment using `dotnetCorePackages.combinePackages`:

```nix
with import <nixpkgs> {};

mkShell {
  name = "dotnet-env";
  packages = [
    (with dotnetCorePackages; combinePackages [
      sdk_3_1
      sdk_5_0
    ])
  ];
}
```

This will produce a dotnet installation that has the dotnet 3.1, 3.0, and 2.1 sdk. The first sdk listed will have it's cli utility present in the resulting environment. Example info output:

```ShellSession
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

## dotnet-sdk vs dotnetCorePackages.sdk {#dotnet-sdk-vs-dotnetcorepackages.sdk}

The `dotnetCorePackages.sdk_X_Y` is preferred over the old dotnet-sdk as both major and minor version are very important for a dotnet environment. If a given minor version isn't present (or was changed), then this will likely break your ability to build a project.

## dotnetCorePackages.sdk vs dotnetCorePackages.runtime vs dotnetCorePackages.aspnetcore {#dotnetcorepackages.sdk-vs-dotnetcorepackages.runtime-vs-dotnetcorepackages.aspnetcore}

The `dotnetCorePackages.sdk` contains both a runtime and the full sdk of a given version. The `runtime` and `aspnetcore` packages are meant to serve as minimal runtimes to deploy alongside already built applications.

## Packaging a Dotnet Application {#packaging-a-dotnet-application}

To package Dotnet applications, you can use `buildDotnetModule`. This has similar arguments to `stdenv.mkDerivation`, with the following additions:

* `projectFile` has to be used for specifying the dotnet project file relative to the source root. These usually have `.sln` or `.csproj` file extensions.
* `nugetDeps` has to be used to specify the NuGet dependency file. Unfortunately, these cannot be deterministically fetched without a lockfile. This file should be generated using `nuget-to-nix` tool, which is available in nixpkgs.
* `executables` is used to specify which executables get wrapped to `$out/bin`, relative to `$out/lib/$pname`. If this is unset, all executables generated will get installed. If you do not want to install any, set this to `[]`.
* `runtimeDeps` is used to wrap libraries into `LD_LIBRARY_PATH`. This is how dotnet usually handles runtime dependencies.
* `buildType` is used to change the type of build. Possible values are `Release`, `Debug`, etc. By default, this is set to `Release`.
* `dotnet-sdk` is useful in cases where you need to change what dotnet SDK is being used.
* `dotnet-runtime` is useful in cases where you need to change what dotnet runtime is being used. This can be either a regular dotnet runtime, or an aspnetcore.
* `dotnet-test-sdk` is useful in cases where unit tests expect a different dotnet SDK. By default, this is set to the `dotnet-sdk` attribute.
* `testProjectFile` is useful in cases where the regular project file does not contain the unit tests. By default, this is set to the `projectFile` attribute.
* `disabledTests` is used to disable running specific unit tests. This gets passed as: `dotnet test --filter "FullyQualifiedName!={}"`, to ensure compatibility with all unit test frameworks.
* `dotnetRestoreFlags` can be used to pass flags to `dotnet restore`.
* `dotnetBuildFlags` can be used to pass flags to `dotnet build`.
* `dotnetTestFlags` can be used to pass flags to `dotnet test`.
* `dotnetInstallFlags` can be used to pass flags to `dotnet install`.
* `dotnetFlags` can be used to pass flags to all of the above phases.

Here is an example `default.nix`, using some of the previously discussed arguments:
```nix
{ lib, buildDotnetModule, dotnetCorePackages, ffmpeg }:

buildDotnetModule rec {
  pname = "someDotnetApplication";
  version = "0.1";

  src = ./.;

  projectFile = "src/project.sln";
  nugetDeps = ./deps.nix; # File generated with `nuget-to-nix path/to/src > deps.nix`.

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.net_5_0;
  dotnetFlags = [ "--runtime linux-x64" ];

  executables = [ "foo" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.
  executables = []; # Don't install any executables.

  runtimeDeps = [ ffmpeg ]; # This will wrap ffmpeg's library path into `LD_LIBRARY_PATH`.
}
```
