{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  mono,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Nuget";
  version = "6.6.1.2";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "linux-packaging-nuget";
    rev = "upstream/${finalAttrs.version}.bin";
    hash = "sha256-9/dSeVshHbpYIgGE/8OzrB4towrWVB3UxDi8Esmbu7Y=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}/

    mkdir -p $out/bin
    makeWrapper \
      "${mono}/bin/mono" \
      "$out/bin/nuget" \
      --add-flags "$out/lib/${finalAttrs.pname}/nuget.exe"

    runHook postInstall
  '';

  meta = {
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
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.mdarocha ];
    inherit (mono.meta) platforms;
  };
})
