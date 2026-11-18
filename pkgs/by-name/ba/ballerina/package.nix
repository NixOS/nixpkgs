{
  ballerina,
  lib,
  writeText,
  writeScript,
  runCommand,
  makeWrapper,
  fetchzip,
  stdenv,
  openjdk21_headless,
}:
let
  version = "2201.13.4";
  codeName = "swan-lake";
  openjdk = openjdk21_headless;
in
stdenv.mkDerivation {
  pname = "ballerina";
  inherit version;

  src = fetchzip {
    url = "https://dist.ballerina.io/downloads/${version}/ballerina-${version}-${codeName}.zip";
    hash = "sha256-te7ZW9CISAg0ahkFBBWW2Q6pkB9jXGNBDHw6slX2V/E=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    cp -rv distributions/ballerina-${version} $out
    runHook postInstall
  '';
  preFixup = ''
    wrapProgram $out/bin/bal --set JAVA_HOME ${openjdk}
  '';

  passthru.tests.smokeTest =
    let
      helloWorld = writeText "hello-world.bal" ''
        import ballerina/io;
        public function main() {
          io:println("Hello, World!");
        }
      '';
    in
    runCommand "ballerina-${version}-smoketest" { } ''
      ${ballerina}/bin/bal run ${helloWorld} >$out
      read result <$out
      [[ $result = "Hello, World!" ]]
    '';

  passthru.updateScript = writeScript "update-ballerina" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl pcre2
    set -euo pipefail

    version="$(curl -s https://ballerina.io/downloads/ |
      pcre2grep -o '(?<=swan-lake-)\d+(?:\.\d+)+(?=)')"

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$version"
  '';

  meta = {
    description = "Open-source programming language for the cloud";
    mainProgram = "bal";
    license = lib.licenses.asl20;
    platforms = openjdk.meta.platforms;
    maintainers = with lib.maintainers; [ cbrxyz ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
