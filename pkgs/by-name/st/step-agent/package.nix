{
  lib,
  fetchurl,
  installShellFiles,
  stdenvNoCC,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  p11-kit,
  polkit,
  tpm2-openssl,
  tpm2-tss,
  nix-update-script,
}:
let
  version = "0.67.3";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/smallstep/step-agent-plugin/releases/download/v${version}/step-agent_${version}_linux_amd64.tar.gz";
      sha256 = "sha256-sTZ6dNjyRwCWHWROUKCpq1rb8n9lT0cGOUOUpui9NJM=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/smallstep/step-agent-plugin/releases/download/v${version}/step-agent_${version}_linux_arm64.tar.gz";
      sha256 = "sha256-0Vefuc+Xnx8x6Gu+WuS4zTHDIMepY593uFi3JKD+hrk=";
    };
  };
in
stdenvNoCC.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;

  inherit version;
  pname = "step-agent";

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    autoPatchelfHook
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./step-agent $out/bin/step-agent
    wrapProgram $out/bin/step-agent --prefix PATH : ${
      lib.makeBinPath [
        tpm2-tss
        tpm2-openssl
        polkit
        p11-kit
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "step-agent is an automated certificate management agent plugin for step-cli";
    homepage = "https://github.com/smallstep/step-agent-plugin/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Srylax ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.linux;
    mainProgram = "step-agent";
  };
}
