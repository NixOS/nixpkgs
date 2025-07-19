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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    rev = "v${version}";
    hash = "sha256-mhSX2yx+/xDwCtLVb+aSFFxP2TOJek/ZX/28khvetwE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6BsRgxcUtVuN1gp3VVXkNQzqb9hD5rWWctieJvFdyrQ=";

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
