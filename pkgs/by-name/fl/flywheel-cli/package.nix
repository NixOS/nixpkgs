{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  os =
    {
      x86_64-darwin = "darwin";
      x86_64-linux = "linux";
    }
    .${system} or throwSystem;

  sha256 =
    {
      x86_64-darwin = "sha256-OIyEu3Hsobui9s5+T9nC10SxMw0MhgmTA4SN9Ridyzo=";
      x86_64-linux = "sha256-SxBjRd95hoh2zwX6IDnkZnTWVduQafPHvnWw8qTuM78=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "flywheel-cli";
  version = "16.2.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/flywheel-dist/cli/${version}/fw-${os}_amd64-${version}.zip";
    inherit sha256;
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip ${src}
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin ./${os}_amd64/fw
    runHook postInstall
  '';

  meta = with lib; {
    description = "Library and command line interface for interacting with a Flywheel site";
    mainProgram = "fw";
    homepage = "https://gitlab.com/flywheel-io/public/python-cli";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ rbreslow ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
