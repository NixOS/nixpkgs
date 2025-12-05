{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  xorg,
  vulkan-loader,
}:

rustPlatform.buildRustPackage rec {
  pname = "binocle";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "binocle";
    rev = "v${version}";
    sha256 = "sha256-WAk7xIrCRfVofn4w+gP5E3wnSZbXm/6MZWlNmtoLm20=";
  };

  cargoHash = "sha256-AUmDubbi6y1SaHZazr2xZc+16SQhI6WBnPg6I7rv3K4=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapProgram $out/bin/binocle \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          with xorg;
          [
            libX11
            libXcursor
            libXi
            libXrandr
          ]
          ++ [ vulkan-loader ]
        )
      }
  '';

  meta = with lib; {
    description = "Graphical tool to visualize binary data";
    mainProgram = "binocle";
    homepage = "https://github.com/sharkdp/binocle";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
  };
}
