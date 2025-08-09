{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  undmg,
}:
let
  pname = "insomnia";
  version = "11.0.1";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.dmg";
          hash = "sha256-3LjQYFCIIrjEQ+J0m7Xau3qcHMRR3xU078QOVgoBat4=";
        };
        x86_64-darwin = {
          url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.dmg";
          hash = "sha256-3LjQYFCIIrjEQ+J0m7Xau3qcHMRR3xU078QOVgoBat4=";
        };
        x86_64-linux = {
          url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.AppImage";
          hash = "sha256-X0UiD+IhyMTrUmsgocw0bpRZEk5YNEF3CMo3IkwKtvA=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    homepage = "https://insomnia.rest";
    description = "Open-source, cross-platform API client for GraphQL, REST, WebSockets, SSE and gRPC, with Cloud, Local and Git storage";
    mainProgram = "insomnia";
    changelog = "https://github.com/Kong/insomnia/releases/tag/core@${version}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      markus1189
      kashw2
      DataHearth
    ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;
    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      mv Insomnia.app $out/Applications/
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands =
      let
        appimageContents = appimageTools.extract {
          inherit pname version src;
        };
      in
      ''
        # Install XDG Desktop file and its icon
        install -Dm444 ${appimageContents}/insomnia.desktop -t $out/share/applications
        install -Dm444 ${appimageContents}/insomnia.png -t $out/share/pixmaps
        # Replace wrong exec statement in XDG Desktop file
        substituteInPlace $out/share/applications/insomnia.desktop \
            --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=insomnia'
      '';
  }
