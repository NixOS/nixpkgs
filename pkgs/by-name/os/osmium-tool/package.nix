{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  pandoc,
  boost,
  bzip2,
  expat,
  libosmium,
  lz4,
  nlohmann_json,
  protozero,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmium-tool";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-l6C2DGGKcbMUkKDruM8QzpriqFMvDnsi4OE99a2EzhA=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    pandoc
  ];

  buildInputs = [
    boost
    bzip2
    expat
    libosmium
    lz4
    nlohmann_json
    protozero
    zlib
  ];

  doCheck = true;

  postInstall = ''
    installShellCompletion --zsh ../zsh_completion/_osmium
  '';

  meta = {
    description = "Multipurpose command line tool for working with OpenStreetMap data based on the Osmium library";
    homepage = "https://osmcode.org/osmium-tool/";
    changelog = "https://github.com/osmcode/osmium-tool/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      mit
      bsd3
    ];
    maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ das-g ]);
    mainProgram = "osmium";
  };
})
