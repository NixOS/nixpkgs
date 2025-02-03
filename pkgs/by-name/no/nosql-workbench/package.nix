{
  appimageTools,
  lib,
  fetchurl,
  jdk21,
  stdenv,
  _7zz
}:
let
  pname = "nosql-workbench";
  version = "3.11.0";

  src = fetchurl {
    x86_64-darwin = {
      url = "https://s3.amazonaws.com/nosql-workbench/NoSQL%20Workbench-mac-x64-${version}.dmg";
      hash = "sha256-KM3aDDsQGZwUKU/or0eOoP8okAOPH7q8KL46RwfqhzM=";
    };
    aarch64-darwin = {
      url = "https://s3.amazonaws.com/nosql-workbench/NoSQL%20Workbench-mac-arm64-${version}.dmg";
      hash = "sha256-LzHiCMrDOWDuMNkkojLgKn+UG7x76wSAz0BapyWkAzU=";
    };
    x86_64-linux = {
      url = "https://s3.amazonaws.com/nosql-workbench/NoSQL%20Workbench-linux-${version}.AppImage";
      hash = "sha256-cDOSbhAEFBHvAluxTxqVpva1GJSlFhiozzRfuM4MK5c=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description = "Visual tool that provides data modeling, data visualization, and query development features to help you design, create, query, and manage DynamoDB tables";
    homepage = "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.html";
    changelog = "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/WorkbenchDocumentHistory.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ DataHearth ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
  };
in
if stdenv.isDarwin then stdenv.mkDerivation {
  inherit pname version src meta;

  sourceRoot = ".";

  # DMG file is using APFS which is unsupported by "undmg".
  # Instead, use "7zz" to extract the contents.
  # "undmg" issue: https://github.com/matthewbauer/undmg/issues/4
  nativeBuildInputs = [ _7zz ];

  buildInputs = [ jdk21 ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    mv NoSQL\ Workbench.app $out/Applications/

    runHook postInstall
  '';

} else appimageTools.wrapType2 {
  inherit pname version src meta;

  extraPkgs = pkgs: [
    # Required to run DynamoDB locally
    pkgs.jdk21
  ];

  extraInstallCommands = let
    appimageContents = appimageTools.extract {
      inherit pname version src;
    };
  in ''
    # Install XDG Desktop file and its icon
    install -Dm444 ${appimageContents}/nosql-workbench.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/nosql-workbench.png -t $out/share/pixmaps

    # Replace wrong exec statement in XDG Desktop file
    substituteInPlace $out/share/applications/nosql-workbench.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=nosql-workbench'
  '';
}
