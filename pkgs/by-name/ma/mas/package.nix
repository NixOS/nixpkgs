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

  src =
    let
      # nix store prefetch-file https://github.com/mas-cli/mas/releases/download/v$VERSION/mas-$VERSION-$ARCH.pkg
      sources =
        {
          x86_64-darwin = {
            arch = "x86_64";
            hash = "sha256-m8od4ftuoZyeC517fIUkkCDJ7WWp1DTC70CJai8zlfk=";
          };
          aarch64-darwin = {
            arch = "arm64";
            hash = "sha256-vCGKhUyF2eHJVJapayYoe7ZgVrlWiLkPkdBPpi7SG3U=";
          };
        }
        .${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/mas-cli/mas/releases/download/v${finalAttrs.version}/mas-${finalAttrs.version}-${sources.arch}.pkg";
      inherit (sources) hash;
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

  meta = {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = lib.licenses.mit;
    mainProgram = "mas";
    maintainers = with lib.maintainers; [
      zachcoyle
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
