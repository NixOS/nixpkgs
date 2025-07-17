{
  comma,
  fetchFromGitHub,
  fzy,
  lib,
  makeBinaryWrapper,
  nix-index-unwrapped,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "comma";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-Q9s3z/FqkEqCQyvYhH07qlITGGlA8quZcYsK3lO8M8g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yNx0Sc2JnEfndBBPxaeNMWsdWpB9fAUqXUPVNR+NOrM=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/comma \
      --prefix PATH : ${
        lib.makeBinPath [
          fzy
          nix-index-unwrapped
        ]
      }
    ln -s $out/bin/comma $out/bin/,
  '';

  passthru.tests = {
    version = testers.testVersion { package = comma; };
  };

  meta = with lib; {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = licenses.mit;
    mainProgram = "comma";
    maintainers = with maintainers; [ artturin ];
  };
}
