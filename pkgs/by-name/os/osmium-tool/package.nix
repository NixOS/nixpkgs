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
  protozero,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "osmium-tool";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    rev = "v${version}";
    sha256 = "sha256-DObqbzdPA4RlrlcZhqA0MQtWBE+D6GRD1pd9U4DARIk=";
  };

  patches = [
    # Work around https://github.com/osmcode/osmium-tool/issues/276
    # by applying changes from https://github.com/Tencent/rapidjson/pull/719
    (fetchpatch {
      url = "https://github.com/Tencent/rapidjson/commit/3b2441b87f99ab65f37b141a7b548ebadb607b96.patch";
      hash = "sha256-Edmq+hdJQFQ4hT3Oz1cv5gX95qQxPLD4aY8QMTonDe8=";
    })
    (fetchpatch {
      url = "https://github.com/Tencent/rapidjson/commit/862c39be371278a45a88d4d1d75164be57bb7e2d.patch";
      hash = "sha256-V5zbq/THUY75p1RdEPKJK2NVnxbZs07MMwJBAH7nAMg=";
    })
    (fetchpatch {
      url = "https://github.com/osmcode/osmium-tool/commit/1c62771a62f260b07c1b9a52338a24a978dcd967.patch";
      hash = "sha256-/2HUu4tLRZzoCcGVEM61gE4RjiA2XGalr9OnhCUhKj8=";
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
    protozero
    zlib
  ];

  doCheck = true;

  postInstall = ''
    installShellCompletion --zsh ../zsh_completion/_osmium
  '';

  meta = with lib; {
    description = "Multipurpose command line tool for working with OpenStreetMap data based on the Osmium library";
    homepage = "https://osmcode.org/osmium-tool/";
    changelog = "https://github.com/osmcode/osmium-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      gpl3Plus
      mit
      bsd3
    ];
    maintainers = with maintainers; teams.geospatial.members ++ [ das-g ];
    mainProgram = "osmium";
  };
}
