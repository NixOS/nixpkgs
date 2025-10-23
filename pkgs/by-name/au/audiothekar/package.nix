{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  audiothekar,
  testers,
}:

buildDotnetModule rec {
  pname = "audiothekar";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fxsth";
    repo = "audiothekar";
    tag = "v${version}";
    sha256 = "sha256-DZ4E8numXJdkvX5WYM6cioW5J89YuD9Hi8NfK+Z39cY=";
  };

  projectFile = "Audiothekar.sln";

  # > Unable to use package assets cache due to I/O error. This can occur when
  # > the same project is built more than once in parallel. Performance may be
  # > degraded, but the build result will not be impacted.
  enableParallelBuilding = false;

  doCheck = false;

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  postInstall = ''
    install -m 644 -D -t "$out/share/doc/${pname}" License.md
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Download-Client für die ARD-Audiothek";
    longDescription = ''
      Audiothekar is a command line client to browse and download programs from
      German public broadcast online offering at https://www.ardaudiothek.de/.
    '';
    homepage = "https://github.com/fxsth/Audiothekar";
    license = licenses.mit;
    maintainers = with maintainers; [
      wamserma
    ];
    platforms = [ "x86_64-linux" ]; # needs some work to enable dotnet-sdk.meta.platforms;
    mainProgram = "audiothekar-cli";
  };
}
