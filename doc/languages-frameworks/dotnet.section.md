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

* `projectFile` has to be used for specifying the dotnet project file relative to the source root. These usually have `.sln` or `.csproj` file extensions. This can be an array of multiple projects as well.
* `nugetDeps` takes either a path to a `deps.nix` file, or a derivation. The `deps.nix` file can be generated using the script attached to `passthru.fetch-deps`. This file can also be generated manually using `nuget-to-nix` tool, which is available in nixpkgs. If the argument is a derivation, it will be used directly and assume it has the same output as `mkNugetDeps`.
* `packNupkg` is used to pack project as a `nupkg`, and installs it to `$out/share`. If set to `true`, the derivation can be used as a dependency for another dotnet project by adding it to `projectReferences`.
* `projectReferences` can be used to resolve `ProjectReference` project items. Referenced projects can be packed with `buildDotnetModule` by setting the `packNupkg = true` attribute and passing a list of derivations to `projectReferences`. Since we are sharing referenced projects as NuGets they must be added to csproj/fsproj files as `PackageReference` as well.
 For example, your project has a local dependency:
 ```xml
     <ProjectReference Include="../foo/bar.fsproj" />
 ```
 To enable discovery through `projectReferences` you would need to add:
 ```xml
     <ProjectReference Include="../foo/bar.fsproj" />
     <PackageReference Include="bar" Version="*" Condition=" '$(ContinuousIntegrationBuild)'=='true' "/>
  ```
* `executables` is used to specify which executables get wrapped to `$out/bin`, relative to `$out/lib/$pname`. If this is unset, all executables generated will get installed. If you do not want to install any, set this to `[]`. This gets done in the `preFixup` phase.
* `runtimeDeps` is used to wrap libraries into `LD_LIBRARY_PATH`. This is how dotnet usually handles runtime dependencies.
* `buildType` is used to change the type of build. Possible values are `Release`, `Debug`, etc. By default, this is set to `Release`.
* `selfContainedBuild` allows to enable the [self-contained](https://docs.microsoft.com/en-us/dotnet/core/deploying/#publish-self-contained) build flag. By default, it is set to false and generated applications have a dependency on the selected dotnet runtime. If enabled, the dotnet runtime is bundled into the executable and the built app has no dependency on Dotnet.
* `dotnet-sdk` is useful in cases where you need to change what dotnet SDK is being used.
* `dotnet-runtime` is useful in cases where you need to change what dotnet runtime is being used. This can be either a regular dotnet runtime, or an aspnetcore.
* `dotnet-test-sdk` is useful in cases where unit tests expect a different dotnet SDK. By default, this is set to the `dotnet-sdk` attribute.
* `testProjectFile` is useful in cases where the regular project file does not contain the unit tests. It gets restored and build, but not installed. You may need to regenerate your nuget lockfile after setting this.
* `disabledTests` is used to disable running specific unit tests. This gets passed as: `dotnet test --filter "FullyQualifiedName!={}"`, to ensure compatibility with all unit test frameworks.
* `dotnetRestoreFlags` can be used to pass flags to `dotnet restore`.
* `dotnetBuildFlags` can be used to pass flags to `dotnet build`.
* `dotnetTestFlags` can be used to pass flags to `dotnet test`. Used only if `doCheck` is set to `true`.
* `dotnetInstallFlags` can be used to pass flags to `dotnet install`.
* `dotnetPackFlags` can be used to pass flags to `dotnet pack`. Used only if `packNupkg` is set to `true`.
* `dotnetFlags` can be used to pass flags to all of the above phases.

When packaging a new application, you need to fetch it's dependencies. You can set `nugetDeps` to an empty string to make the derivation temporarily evaluate, and then run `nix-build -A package.passthru.fetch-deps` to generate it's dependency fetching script. After running the script, you should have the location of the generated lockfile printed to the console. This can be copied to a stable directory. Note that if either `projectFile` or `nugetDeps` are unset, this script cannot be generated!

Here is an example `default.nix`, using some of the previously discussed arguments:
```nix
{ lib, buildDotnetModule, dotnetCorePackages, ffmpeg }:

let
  referencedProject = import ../../bar { ... };
in buildDotnetModule rec {
  pname = "someDotnetApplication";
  version = "0.1";

  src = ./.;

  projectFile = "src/project.sln";
  nugetDeps = ./deps.nix; # File generated with `nix-build -A package.passthru.fetch-deps`.

  projectReferences = [ referencedProject ]; # `referencedProject` must contain `nupkg` in the folder structure.

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.net_5_0;
  dotnetFlags = [ "--runtime linux-x64" ];

  executables = [ "foo" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.
  executables = []; # Don't install any executables.

  packNupkg = true; # This packs the project as "foo-0.1.nupkg" at `$out/share`.

  runtimeDeps = [ ffmpeg ]; # This will wrap ffmpeg's library path into `LD_LIBRARY_PATH`.
}
```
