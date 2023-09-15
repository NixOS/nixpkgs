{ stdenv, fetchFromGitHub, makeWrapper, mono, lib }:

stdenv.mkDerivation (attrs: {
  pname = "Nuget";
  version = "6.3.1.1";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "linux-packaging-nuget";
    rev = "upstream/${attrs.version}.bin";
    sha256 = "sha256-D7F4B23HK5ElY68PYKVDsyi8OF0DLqqUqQzj5CpMfkc=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/lib/${attrs.pname}
    cp -r . $out/lib/${attrs.pname}/

    mkdir -p $out/bin
    makeWrapper \
      "${mono}/bin/mono" \
      "$out/bin/nuget" \
      --add-flags "$out/lib/${attrs.pname}/nuget.exe"
  '';

  meta = with lib; {
    description = "A package manager for the .NET platform";
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
    platforms = [ "x86_64-linux" ];
  };
})
