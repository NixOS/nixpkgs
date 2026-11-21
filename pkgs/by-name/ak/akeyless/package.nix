{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
}:

let
  version = "1.143.0";

  completionSrc = fetchurl {
    url = "https://download.akeyless.io/Akeyless_Artifacts/Linux/CLI/akeyless.bash_completion";
    hash = "sha256-ZNS8FWcBwu7QFtH7joJiAWctuA8Ny7SGXRmlBbrxaQo=";
  };

  srcs = {
    x86_64-darwin = {
      url = "https://download.akeyless.io/Akeyless_Artifacts/MacOS/CLI/akeyless";
      hash = "sha256-O4rFqbTnVbCRvk7V6CN0CHd78pZoFekhjb5Abkyltco=";
    };
    aarch64-darwin = {
      url = "https://download.akeyless.io/Akeyless_Artifacts/MacOS/CLI/akeyless-arm";
      hash = "sha256-OaAO9y2G+5Q4y3Cjpm4aYyD/M6OAU8fpReVh5IJpzsw=";
    };
    x86_64-linux = {
      url = "https://download.akeyless.io/Akeyless_Artifacts/Linux/CLI/akeyless";
      hash = "sha256-4KsH8YWPGhot3XyvVJFStRj5A8FYhpDEsnpgqU6JhIY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "akeyless";
  inherit version;

  src = fetchurl (
    srcs.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}")
  );

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/akeyless
    installShellCompletion --bash --name akeyless ${completionSrc}
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Akeyless CLI";
    homepage = "https://www.akeyless.io";
    license = lib.licenses.unfree;
    mainProgram = "akeyless";
    maintainers = with lib.maintainers; [ frantathefranta ];
    platforms = lib.attrNames srcs;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
