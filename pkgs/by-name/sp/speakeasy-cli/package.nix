{ lib
, stdenv
, fetchurl
, unzip
, nixosTests
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "speakeasy-cli does not support system: ${system}";

  pname = "speakeasy-cli";

  x86_64-darwin-version = "1.129.1";
  x86_64-darwin-sha256  = "sha256-b1D+Xzrjbp8e5PIc33h8+GLmOi9vlA8owP//Fp/6uXQ=";

  x86_64-linux-version = "1.129.1";
  x86_64-linux-sha256  = "sha256-Ez1m66IIDOPq+aAuJZGZFkXp+JhtfPe7o1LFiks9ccA=";

  aarch64-darwin-version = "1.129.1";
  aarch64-darwin-sha256  = "sha256-uLbjUxK2UsCp6Eedf/8b7QgRQJZps9llQBst8NPsFuE=";

  aarch64-linux-version = "1.129.1";
  aarch64-linux-sha256  = "sha256-INQ3Xc5bYDRX+C+mEPXhRX1DAV8/Ph7IqAzd9ApgGbY=";

  version = {
    x86_64-darwin   = x86_64-darwin-version;
    x86_64-linux    = x86_64-linux-version;
    aarch64-darwin  =  aarch64-darwin-version;
    aarch64-linux   =  aarch64-linux-version;
  }.${system} or throwSystem;

  src = let
    base = "https://github.com/speakeasy-api/speakeasy/releases/download";
  in {
    x86_64-darwin = fetchurl {
      url    = "${base}/v${version}/speakeasy_darwin_amd64.zip";
      hash   = x86_64-darwin-sha256;
    };
    x86_64-linux = fetchurl {
      url    = "${base}/v${version}/speakeasy_linux_amd64.zip";
      hash   = x86_64-linux-sha256;
    };
    aarch64-darwin = fetchurl {
      url    = "${base}/v${version}/speakeasy_darwin_arm64.zip";
      hash   = aarch64-darwin-sha256;
    };
    aarch64-linux = fetchurl {
      url    = "${base}/v${version}/speakeasy_linux_arm64.zip";
      hash   = aarch64-linux-sha256;
    };
  }.${system} or throwSystem;

  meta = with lib; {
    description = "CLI tool for Speakeasy";
    mainProgram = "speakeasy";
    changelog   = "https://github.com/speakeasy-api/speakeasy/releases";
    platforms   = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    homepage    = "https://www.speakeasyapi.dev/";
    license     = licenses.elastic20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

in

  stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ unzip ];

    dontConfigure = true;
    dontBuild = true;
    dontPatch = true;
    dontFixup = true;

    unpackPhase = ''
      runHook preUnpack

      mkdir -p out
      unzip "${src}" -d ./out

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall;

      mkdir -p "$out/bin";

      chmod a+x ./out/speakeasy;
      cp -r ./out/* "$out";
      mv "$out/speakeasy" "$out/bin/"

      runHook postInstall
    '';

    passthru.tests = { inherit (nixosTests) speakeasy-cli; };
  }
