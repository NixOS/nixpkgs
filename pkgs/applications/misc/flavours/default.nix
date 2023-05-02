{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-48f05kIojCCANxV2rGmyXvGVqID2Wy0uh/YavR8d3XI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoHash = "sha256-YeIiyyGjjXoyuQ2td393LuiyvDmLZdoWf2BGYWqynD4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd flavours \
      --zsh <($out/bin/flavours --completions zsh) \
      --fish <($out/bin/flavours --completions fish) \
      --bash <($out/bin/flavours --completions bash)
  '';

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k misterio77 ];
  };
}
