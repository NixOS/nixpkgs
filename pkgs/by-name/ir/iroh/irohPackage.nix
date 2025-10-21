{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

{
  features ? [ ],
  targetBinary ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iroh";
  version = "0.93.2";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IYuOo4dfTC7IfMkwFyjqFmOYjx87i84+ydyNxnSAfk4=";
  };

  cargoHash = "sha256-aR78AKfXRAePnOVO/Krx1WGcQgOIz3d+GDwfAoM10UQ=";

  # Some tests require network access which is not available in nix build sandbox.
  doCheck = false;

  cargoBuildFlags =
    let
      featureFlag = lib.optionals (features != [ ]) (
        "--features ${(lib.strings.concatStringsSep "," features)}"
      );

      binaryFlag = lib.optionals (!isNull targetBinary) ("--bin ${targetBinary}");
    in
    [
      featureFlag
      binaryFlag
    ];

  meta = {
    description = "Efficient IPFS for the whole world right now";
    homepage = "https://iroh.computer";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cameronfyfe matthiasbeyer ];
    mainProgram = "iroh";
  };
})
