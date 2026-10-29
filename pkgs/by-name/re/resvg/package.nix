{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "linebender";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3u+NvpiBV1Q56pE5sLpoeqGoKjxLcr3PfXKZNtYKBR8=";
  };

  cargoHash = "sha256-CVnU64Yi//vZz6rza05teA8bFlhbgdeky0Bd7RvIX7M=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  postInstall = ''
    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  meta = {
    description = "SVG rendering library";
    homepage = "https://github.com/linebender/resvg";
    changelog = "https://github.com/linebender/resvg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = [ lib.maintainers.jopejoe1 ];
    mainProgram = "resvg";
  };
})
