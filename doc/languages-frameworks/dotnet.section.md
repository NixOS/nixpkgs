# Dotnet {#dotnet}

## Local Development Workflow {#local-development-workflow}

For local development, it's recommended to use nix-shell to create a dotnet environment:

```nix
# shell.nix
with import <nixpkgs> {};

mkShell {
  name = "dotnet-env";
  packages = [
    dotnet-sdk
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
      sdk_6_0
      sdk_7_0
    ])
  ];
}
```

This will produce a dotnet installation that has the dotnet 6.0 7.0 sdk. The first sdk listed will have it's cli utility present in the resulting environment. Example info output:

```ShellSession
$ dotnet --info
.NET SDK:
 Version:   7.0.202
 Commit:    6c74320bc3

Środowisko uruchomieniowe:
 OS Name:     nixos
 OS Version:  23.05
 OS Platform: Linux
 RID:         linux-x64
 Base Path:   /nix/store/n2pm44xq20hz7ybsasgmd7p3yh31gnh4-dotnet-sdk-7.0.202/sdk/7.0.202/

Host:
  Version:      7.0.4
  Architecture: x64
  Commit:       0a396acafe

.NET SDKs installed:
  6.0.407 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/sdk]
  7.0.202 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/sdk]

.NET runtimes installed:
  Microsoft.AspNetCore.App 6.0.15 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/shared/Microsoft.AspNetCore.App]
  Microsoft.AspNetCore.App 7.0.4 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 6.0.15 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 7.0.4 [/nix/store/3b19303vwrhv0xxz1hg355c7f2hgxxgd-dotnet-core-combined/shared/Microsoft.NETCore.App]

Other architectures found:
  None

Environment variables:
  Not set

global.json file:
  Not found

Learn more:
  https://aka.ms/dotnet/info

Download .NET:
  https://aka.ms/dotnet/download
```

## dotnet-sdk vs dotnetCorePackages.sdk {#dotnet-sdk-vs-dotnetcorepackages.sdk}

The `dotnetCorePackages.sdk_X_Y` is preferred over the old dotnet-sdk as both major and minor version are very important for a dotnet environment. If a given minor version isn't present (or was changed), then this will likely break your ability to build a project.

## dotnetCorePackages.sdk vs dotnetCorePackages.runtime vs dotnetCorePackages.aspnetcore {#dotnetcorepackages.sdk-vs-dotnetcorepackages.runtime-vs-dotnetcorepackages.aspnetcore}

The `dotnetCorePackages.sdk` contains both a runtime and the full sdk of a given version. The `runtime` and `aspnetcore` packages are meant to serve as minimal runtimes to deploy alongside already built applications.

## Packaging a Dotnet Application {#packaging-a-dotnet-application}

To package Dotnet applications, you can use `buildDotnetModule`. This has similar arguments to `stdenv.mkDerivation`, with the following additions:

* `projectFile` is used for specifying the dotnet project file, relative to the source root. These usually have `.sln` or `.csproj` file extensions. This can be a list of multiple projects as well. Most of the time dotnet can figure this location out by itself, so this should only be set if necessary.
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
* `dotnet-sdk` is useful in cases where you need to change what dotnet SDK is being used. You can also set this to the result of `dotnetSdkPackages.combinePackages`, if the project uses multiple SDKs to build.
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

When packaging a new application, you need to fetch its dependencies. You can run `nix-build -A package.fetch-deps` to generate a script that will build a lockfile for you. After running the script you should have the location of the generated lockfile printed to the console, which can be copied to a stable directory. Then set `nugetDeps = ./deps.nix` and you're ready to build the derivation.

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

  dotnet-sdk = dotnetCorePackages.sdk_6.0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  executables = [ "foo" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.
  executables = []; # Don't install any executables.

  packNupkg = true; # This packs the project as "foo-0.1.nupkg" at `$out/share`.

  runtimeDeps = [ ffmpeg ]; # This will wrap ffmpeg's library path into `LD_LIBRARY_PATH`.
}
```
