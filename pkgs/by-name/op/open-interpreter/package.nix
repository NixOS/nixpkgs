{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}:

let
  version = "0.0.40";

  systemMap = {
    "x86_64-linux" = {
      filename = "open-interpreter-package-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-OEDGd/saB0Z/r8bTTQb3IAQQ4fHE8vqBTsTdfkcJczM=";
    };
    "aarch64-linux" = {
      filename = "open-interpreter-package-aarch64-unknown-linux-musl.tar.gz";
      hash = "sha256-eGNkSpm5pwqF07VYdFVntVxe1UAv/EGrLdh2ZnMALug=";
    };
    "x86_64-darwin" = {
      filename = "open-interpreter-package-x86_64-apple-darwin.tar.gz";
      hash = "sha256-d6odpO5Fd4GGVq663wey4fZCfUNn0N9AD5APmSDry8g=";
    };
    "aarch64-darwin" = {
      filename = "open-interpreter-package-aarch64-apple-darwin.tar.gz";
      hash = "sha256-qMKnCaOOR1GSDttsFgo4jXRk4gjNPpVkq9Ph3Wmp+Dc=";
    };
  };

  sysAttrs =
    systemMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system architecture: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation rec {
  pname = "open-interpreter";
  inherit version;

  src = fetchurl {
    url = "https://github.com/openinterpreter/openinterpreter/releases/download/rust-v${version}/${sysAttrs.filename}";
    hash = sysAttrs.hash;
  };

  sourceRoot = ".";
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/open-interpreter

    find . -mindepth 1 -maxdepth 1 ! -name "$out" -exec cp -r {} $out/libexec/open-interpreter/ \;

    chmod +x $out/libexec/open-interpreter/bin/* 2>/dev/null || true
    chmod +x $out/libexec/open-interpreter/codex-path/rg 2>/dev/null || true

    makeWrapper $out/libexec/open-interpreter/bin/interpreter $out/bin/interpreter
    makeWrapper $out/libexec/open-interpreter/bin/interpreter $out/bin/i

    runHook postInstall
  '';

  meta = with lib; {
    description = "The open-source terminal agent built for low-cost models";
    homepage = "https://github.com/openinterpreter/openinterpreter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      _2hexed
      happysalada
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "interpreter";
  };
}
