{
  keystone,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
}:
let
  version = "1.0.1";
  pname = "CLPS2C-Compiler";
  owner = "NiV-L-A";
  keystone-rev = "MIPS-0.9.2";
  keystone-sha256 = "sha256-xLkO06ZgnmAavJMP1kjDwXT1hc5eSDXv+4MUkOz6xeo=";
  keystone-src = (
    fetchFromGitHub {
      name = "keystone";
      inherit owner;
      repo = "keystone";
      rev = keystone-rev;
      sha256 = keystone-sha256;
    }
  );
  keystone-override = keystone.overrideAttrs (old: {
    src = keystone-src;
  });
in
buildDotnetModule rec {
  inherit version pname;

  srcs = [
    (fetchFromGitHub {
      name = pname;
      inherit owner;
      repo = "CLPS2C-Compiler";
      rev = "CLPS2C-Compiler-${version}";
      sha256 = "sha256-4gLdrIxyw9BFSxF+EXZqTgUf9Kik6oK7eO9HBUzk4QM=";
    })
    keystone-src
  ];

  sourceRoot = ".";

  patches = [
    ./patches/dont_trim_leading_newline.patch
    ./patches/build_fixes.patch
    ./patches/remove_platformtarget.patch
    ./patches/use_compiled_keystone.patch
    ./patches/set_langversion.patch
    ./patches/set_runtimeidentifiers.patch
    ./patches/keystone_set_targetframework.patch
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetFlags = [
    "-p:TargetFramework=net8.0"
  ];

  nugetDeps = ./deps.json;

  runtimeDeps = [
    keystone-override
  ];

  projectFile = "CLPS2C-Compiler/CLPS2C-Compiler/CLPS2C-Compiler.csproj";

  meta = {
    homepage = "https://github.com/NiV-L-A/CLPS2C-Compiler";
    description = "Compiler for CLPS2C, a domain-specific language built specifically for writing PS2 cheat codes";
    mainProgram = "CLPS2C-Compiler";
    maintainers = [ lib.maintainers.gigahawk ];
    license = lib.licenses.gpl3Only;
  };
}
