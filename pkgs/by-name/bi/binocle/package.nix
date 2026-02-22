{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  vulkan-loader,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "binocle";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "binocle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WAk7xIrCRfVofn4w+gP5E3wnSZbXm/6MZWlNmtoLm20=";
  };

  cargoHash = "sha256-AUmDubbi6y1SaHZazr2xZc+16SQhI6WBnPg6I7rv3K4=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/binocle \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libx11
          libxcursor
          libxi
          libxrandr
          vulkan-loader
        ]
      }
  '';

  meta = {
    description = "Graphical tool to visualize binary data";
    mainProgram = "binocle";
    homepage = "https://github.com/sharkdp/binocle";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
  };
})
