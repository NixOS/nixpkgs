{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  jq,
  libarchive,
  p7zip,
  versionCheckHook,
  zsh,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mas";
  version = "7.0.0";

  __structuredAttrs = true;

  # nix store prefetch-file https://github.com/mas-cli/mas/releases/download/v$VERSION/mas-$VERSION-arm64.pkg
  src = fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${finalAttrs.version}/mas-${finalAttrs.version}-arm64.pkg";
    hash = "sha256-vCGKhUyF2eHJVJapayYoe7ZgVrlWiLkPkdBPpi7SG3U=";
  };

  nativeBuildInputs = [
    installShellFiles
    libarchive
    p7zip
  ];

  unpackPhase = ''
    runHook preUnpack

    7z x $src
    bsdtar -xf Payload~

    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    installBin usr/local/opt/mas/bin/mas
    install -D --mode=755 usr/local/opt/mas/libexec/bin/mas "$out/libexec/bin/mas"

    substituteInPlace "$out/bin/mas" \
      --replace-fail "#!/bin/zsh" "#!${lib.getExe zsh}" \
      --replace-fail "/usr/bin/jq" "${lib.getExe jq}"

    installManPage usr/local/opt/mas/share/man/man1/mas.1
    installShellCompletion --bash usr/local/opt/mas/etc/bash_completion.d/mas
    installShellCompletion --fish usr/local/opt/mas/share/fish/vendor_completions.d/mas.fish

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = lib.licenses.mit;
    mainProgram = "mas";
    maintainers = with lib.maintainers; [
      zachcoyle
      tiferrei
    ];
    platforms = [
      "aarch64-darwin"
    ];
  };
})
