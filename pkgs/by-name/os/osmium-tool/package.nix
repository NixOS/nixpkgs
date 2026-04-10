{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x5qEW4DqOw/vA+IuZA7VC5WRn+uDOZ6dJhyJoi7UKOA=";
  };

  patches = [
    # Fix apply-changes-version-on-version-timestamp test
    (fetchpatch {
      url = "https://github.com/osmcode/osmium-tool/commit/e58501ed1570f19340173c668568790369214d46.patch";
      hash = "sha256-VhdwY1DpfTQAx24Qck0a96GGnEGfg4T27wSeGO1zdng=";
    })
  ];

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

  preCheck = ''
    export OSMIUM_PAGER=cat
  '';

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
