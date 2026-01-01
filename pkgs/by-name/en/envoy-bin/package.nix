{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  nixosTests,
  versionCheckHook,
}:
let
<<<<<<< HEAD
  version = "1.36.4";
=======
  version = "1.36.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "envoy-bin is not available for ${system}.";

  plat =
    {
      aarch64-linux = "aarch_64";
      x86_64-linux = "x86_64";
    }
    .${system} or throwSystem;

  hash =
    {
<<<<<<< HEAD
      aarch64-linux = "sha256-RVUeO6MbI2j7gM9MEkshhXxU4Oga7jtwjr17C6P3VbE=";
      x86_64-linux = "sha256-WjmAldjB3TY+zBC2udvYIVSo+7XrFVENX7fL250LDlk=";
=======
      aarch64-linux = "sha256-r3NrtmU8zpxSsvOwkqNgKsIaYKxnVpjQYNxNgoN8Bco=";
      x86_64-linux = "sha256-r9Z7z+pUhSXudqk1CgpM/rKsJMe1MnlM4zLYQK2M2uc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation {
  pname = "envoy-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/envoyproxy/envoy/releases/download/v${version}/envoy-${version}-linux-${plat}";
    inherit hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 $src $out/bin/envoy
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/envoy";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    tests.envoy-bin = nixosTests.envoy-bin;

    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://envoyproxy.io";
    changelog = "https://github.com/envoyproxy/envoy/releases/tag/v${version}";
    description = "Cloud-native edge and service proxy";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "envoy";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
