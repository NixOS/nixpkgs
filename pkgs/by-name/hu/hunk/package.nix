{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.10.0";

  source = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v${version}";
    hash = "sha256-S2EuZW5vzyk3FGhUQbyanE3hdlnb9F6GQMtu2k8pjrM=";
  };

  sources = {
    x86_64-linux = fetchurl {
      url = "https://registry.npmjs.org/hunkdiff-linux-x64/-/hunkdiff-linux-x64-${version}.tgz";
      hash = "sha256-ICkeeCq8X7czMDtVBH3P5lPDhSrgueZMeQb0QwTcfSA=";
    };
    aarch64-linux = fetchurl {
      url = "https://registry.npmjs.org/hunkdiff-linux-arm64/-/hunkdiff-linux-arm64-${version}.tgz";
      hash = "sha256-+1/uVxcmkyqYSTDz9gk+aZOgTKUzcypgichFfMwnGF4=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hunk";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    install -D bin/hunk -t $out/bin
    install -D LICENSE -t $out/share/licenses/hunk
    install -D ${source}/skills/hunk-review/SKILL.md -t $out/bin/skills/hunk-review

    runHook postInstall
  '';

  dontBuild = true;
  dontStrip = true;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/hunk --version
    $out/bin/hunk skill path

    runHook postInstallCheck
  '';

  meta = {
    description = "Review-first terminal diff viewer for agent-authored changesets";
    homepage = "https://github.com/modem-dev/hunk";
    changelog = "https://github.com/modem-dev/hunk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hunk";
    maintainers = with lib.maintainers; [ dsp ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
