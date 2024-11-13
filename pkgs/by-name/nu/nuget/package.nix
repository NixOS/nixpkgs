{ stdenv, fetchFromGitHub, makeWrapper, mono, lib }:

stdenv.mkDerivation (attrs: {
  pname = "Nuget";
  version = "6.6.1.2";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "linux-packaging-nuget";
    rev = "upstream/${attrs.version}.bin";
    hash = "sha256-9/dSeVshHbpYIgGE/8OzrB4towrWVB3UxDi8Esmbu7Y=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${attrs.pname}
    cp -r . $out/lib/${attrs.pname}/

    mkdir -p $out/bin
    makeWrapper \
      "${mono}/bin/mono" \
      "$out/bin/nuget" \
      --add-flags "$out/lib/${attrs.pname}/nuget.exe"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Package manager for the .NET platform";
    mainProgram = "nuget";
    homepage = "https://www.mono-project.com/";
    longDescription = ''
      NuGet is the package manager for the .NET platform.
      This derivation bundles the Mono NuGet CLI, which is mostly used by
      older projects based on .NET Framework.

      Newer .NET projects can use the dotnet CLI, which has most of this
      packages functionality built-in.
    '';
    # https://learn.microsoft.com/en-us/nuget/resources/nuget-faq#what-is-the-license-for-nuget-exe-
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    maintainers = [ maintainers.mdarocha ];
    inherit (mono.meta) platforms;
  };
})
