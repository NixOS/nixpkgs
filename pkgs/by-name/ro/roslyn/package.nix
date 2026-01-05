{
  lib,
  fetchFromGitHub,
  mono,
  buildDotnetModule,
  dotnetCorePackages,
  unzip,
}:

buildDotnetModule rec {
  pname = "roslyn";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    tag = "NET-SDK-9.0.304";
    hash = "sha256-mj14bpJks7CcrbcEScPkl3feKUycGLiBYXs908GnGhg=";
  };

  dotnet-sdk =
    with dotnetCorePackages;
    sdk_9_0
    // {
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };

  projectFile = [
    "src/NuGet/Microsoft.Net.Compilers.Toolset/Framework/Microsoft.Net.Compilers.Toolset.Framework.Package.csproj"
  ];

  nugetDeps = ./deps.json;

  dontDotnetFixup = true;

  nativeBuildInputs = [ unzip ];

  postPatch = ''
    substituteInPlace global.json \
      --replace-fail "patch" "latestFeature"
  '';

  buildPhase = ''
    runHook preBuild

    dotnet msbuild -v:m -t:pack \
      -p:Configuration=Release \
      -p:RepositoryUrl="${meta.homepage}" \
      -p:RepositoryCommit="v${version}" \
      src/NuGet/Microsoft.Net.Compilers.Toolset/Framework/Microsoft.Net.Compilers.Toolset.Framework.Package.csproj

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pkg="$out/lib/dotnet/microsoft.net.compilers.toolset/${version}"
    mkdir -p "$out/bin" "$pkg"

    unzip -q artifacts/packages/Release/Shipping/Microsoft.Net.Compilers.Toolset.Framework.${version}-dev.nupkg \
      -d "$pkg"
    # nupkg has 0 permissions for a bunch of things
    chmod -R +rw "$pkg"

    makeWrapper ${mono}/bin/mono $out/bin/csc \
      --add-flags "$pkg/tasks/net472/csc.exe"
    makeWrapper ${mono}/bin/mono $out/bin/vbc \
      --add-flags "$pkg/tasks/net472/vbc.exe"

    runHook postInstall
  '';

  meta = with lib; {
    description = ".NET C# and Visual Basic compiler";
    homepage = "https://github.com/dotnet/roslyn";
    mainProgram = "csc";
    license = licenses.mit;
    maintainers = with maintainers; [ corngood ];
  };
}
