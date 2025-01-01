{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  markdownlint-cli2,
  nodejs,
  runCommand,
  zstd,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "markdownlint-cli2";
  version = "0.16.0";

  # upstream is not interested in including package-lock.json in the source
  # https://github.com/DavidAnson/markdownlint-cli2/issues/198#issuecomment-1690529976
  # see also https://github.com/DavidAnson/markdownlint-cli2/issues/186
  # so use the tarball from the archlinux mirror
  src = fetchurl {
    url = "https://us.mirrors.cicku.me/archlinux/extra/os/x86_64/markdownlint-cli2-${finalAttrs.version}-1-any.pkg.tar.zst";
    hash = "sha256-VkT94QS2XeUp2cJLGvK+MZnDdlqmG9szTmzv6lKyxUs=";
  };

  nativeBuildInputs = [
    makeWrapper
    zstd
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r lib share $out
    makeWrapper "${lib.getExe nodejs}" "$out/bin/markdownlint-cli2" \
      --add-flags "$out/lib/node_modules/markdownlint-cli2/markdownlint-cli2.js"

    runHook postInstall
  '';

  passthru.tests = {
    smoke = runCommand "${finalAttrs.pname}-test" { nativeBuildInputs = [ markdownlint-cli2 ]; } ''
      markdownlint-cli2 ${markdownlint-cli2}/share/doc/markdownlint-cli2/README.md > $out
    '';
  };

  meta = {
    changelog = "https://github.com/DavidAnson/markdownlint-cli2/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Fast, flexible, configuration-based command-line interface for linting Markdown/CommonMark files with the markdownlint library";
    homepage = "https://github.com/DavidAnson/markdownlint-cli2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "markdownlint-cli2";
  };
})
