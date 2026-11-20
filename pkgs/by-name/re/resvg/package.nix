{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "linebender";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lsJktYzwkWRzetU+rNLZrZSRT5jSNVPTtbwE3gnT5wk=";
  };

  cargoHash = "sha256-mvQNihyapelGFARE/EsTQV7sExz4ccMZYLIoIy7Yuak=";

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
