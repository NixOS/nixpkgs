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
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6CT5vhzZtGZDr3mCgtpI8AGXn+Iiasf9SxUV6qN9+I8=";
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
    maintainers = with lib.maintainers; [ das-g ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "osmium";
  };
})
