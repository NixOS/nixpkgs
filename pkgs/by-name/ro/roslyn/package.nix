{ lib
, fetchFromGitHub
, mono
, buildDotnetModule
, dotnetCorePackages
, unzip
}:

buildDotnetModule rec {
  pname = "roslyn";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "v${version}";
    hash = "sha256-4iXabFp0LqJ8TXOrqeD+oTAocg6ZTIfijfX3s3fMJuI=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;

  projectFile = [ "src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj" ];

  nugetDeps = ./deps.json;

  dontDotnetFixup = true;

  nativeBuildInputs = [ unzip ];

  postPatch = ''
    sed -i 's/latestPatch/latestFeature/' global.json
  '';

  buildPhase = ''
    runHook preBuild

    dotnet msbuild -v:m -t:pack \
      -p:Configuration=Release \
      -p:RepositoryUrl="${meta.homepage}" \
      -p:RepositoryCommit="v${version}" \
      src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj

    runHook postBuild
  '';

  installPhase = ''
    pkg="$out/lib/dotnet/microsoft.net.compilers.toolset/${version}"
    mkdir -p "$out/bin" "$pkg"

    unzip -q artifacts/packages/Release/Shipping/Microsoft.Net.Compilers.Toolset.${version}-dev.nupkg \
      -d "$pkg"
    # nupkg has 0 permissions for a bunch of things
    chmod -R +rw "$pkg"

    makeWrapper ${mono}/bin/mono $out/bin/csc \
      --add-flags "$pkg/tasks/net472/csc.exe"
    makeWrapper ${mono}/bin/mono $out/bin/vbc \
      --add-flags "$pkg/tasks/net472/vbc.exe"
  '';

  meta = with lib; {
    description = ".NET C# and Visual Basic compiler";
    homepage = "https://github.com/dotnet/roslyn";
    mainProgram = "csc";
    license = licenses.mit;
    maintainers = with maintainers; [ corngood ];
  };
}
