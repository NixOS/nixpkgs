{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  libarchive,
  p7zip,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mas";
  version = "6.0.1";

  __structuredAttrs = true;

  src =
    let
      baseUrl = "https://github.com/mas-cli/mas/releases/download/v${finalAttrs.version}/mas-${finalAttrs.version}";
      sources = {
        x86_64-darwin = fetchurl {
          url = "${baseUrl}-x86_64.pkg";
          hash = "sha256-7+iDBr4GG5bdTuAlAmMQkEkIzVgLo2+DEdravClaLtQ=";
        };
        aarch64-darwin = fetchurl {
          url = "${baseUrl}-arm64.pkg";
          hash = "sha256-BZ9UE8H28kjqiMNdLDUUyC9madR4rBV1mLUGyj6ol3Y=";
        };
      };
    in
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
