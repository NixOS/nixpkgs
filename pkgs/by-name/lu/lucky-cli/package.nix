{
  lib,
  fetchFromGitHub,
  crystal,
  makeWrapper,
  openssl,
}:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    tag = "v${version}";
    hash = "sha256-68As7PSRYwhJGcQwI4FgM9aN0nhNrEjcv+10jKnlXeA=";
  };

  # the integration tests will try to clone a remote repos
  postPatch = ''
    rm -rf spec/integration
  '';

  preConfigure = ''
    substituteInPlace "./src/lucky_cli/version.cr" \
      --replace-fail '`shards version #{__DIR__}`' '"${version}"'
  '';

  format = "crystal";

  lockFile = ./shard.lock;
  shardsFile = ./shards.nix;

  crystalBinaries.lucky.src = "src/lucky.cr";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/lucky \
      --prefix PATH : ${lib.makeBinPath [ crystal ]}
  '';

  meta = {
    description = "Crystal library for creating and running tasks. Also generates Lucky projects";
    homepage = "https://luckyframework.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "lucky";
    platforms = lib.platforms.unix;
    broken = lib.versionOlder crystal.version "1.6.0";
  };
}
