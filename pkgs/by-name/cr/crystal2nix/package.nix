{
  lib,
  fetchFromGitHub,
  crystal,
  makeBinaryWrapper,
  nix-prefetch-git,
}:

crystal.buildCrystalPackage rec {
  pname = "crystal2nix";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "crystal2nix";
    rev = "v${version}";
    hash = "sha256-O8X2kTzl3LYMT97tVqbIZXDcFq24ZTfvd4yeMUhmBFs=";
  };

  format = "shards";

  shardsFile = ./shards.nix;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir -p $out/libexec
    mv $out/bin/${meta.mainProgram} $out/libexec
    makeWrapper $out/libexec/${meta.mainProgram} $out/bin/${meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ nix-prefetch-git ]}
  '';

  # temporarily off. We need the checks to execute the wrapped binary
  doCheck = false;

  doInstallCheck = true;

  meta = with lib; {
    description = "Utility to convert Crystal's shard.lock files to a Nix file";
    mainProgram = "crystal2nix";
    license = licenses.mit;
    maintainers = with maintainers; [
      manveru
      peterhoeg
    ];
  };
}
