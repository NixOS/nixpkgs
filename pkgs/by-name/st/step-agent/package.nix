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
}:
let
  version = "0.69.2";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://packages.smallstep.com/stable/step-agent/linux/${version}/step-agent_${version}_linux_amd64.tar.gz";
      sha256 = "sha256-HIIXGIczw6bqVY05mTaCW0JhZNbgHW8cDKSmeUTzSf0=";
    };

    aarch64-linux = fetchurl {
      url = "https://packages.smallstep.com/stable/step-agent/linux/${version}/step-agent_${version}_linux_arm64.tar.gz";
      sha256 = "sha256-ENT7vn0YqpMX1SrdFTTo3ZV1aVKl2lqZ8e6vwUqDgk4=";
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

  passthru.updateScript = ./update.sh;

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
