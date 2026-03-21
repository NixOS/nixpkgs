{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  libarchive,
  p7zip,
  testers,
  mas,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mas";
  version = "5.1.0";

  src =
    let
      # nix store prefetch-file https://github.com/mas-cli/mas/releases/download/v$VERSION/mas-$VERSION-$ARCH.pkg
      sources =
        {
          x86_64-darwin = {
            arch = "x86_64";
            hash = "sha256-G7o0nHsf6Ay2k3quMs45KH9h4yEpbvyGPm/u86naWcM=";
          };
          aarch64-darwin = {
            arch = "arm64";
            hash = "sha256-XZM0YeFLHYhoEqQLaG1Jz3OWcT9DILqFEcgqI3yvDk8=";
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

    installManPage usr/local/opt/mas/share/man/man1/mas.1
    installShellCompletion --bash usr/local/opt/mas/etc/bash_completion.d/mas
    installShellCompletion --fish usr/local/opt/mas/share/fish/vendor_completions.d/mas.fish

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = mas;
      command = "mas version";
    };
  };

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
