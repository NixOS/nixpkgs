{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kamp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "vbauerster";
    repo = "kamp";
    rev = "v${version}";
    hash = "sha256-coBKVqSqYBpf0PdWKIODnbfQxbOyp5Di45+O66ZGK1Q=";
  };

  cargoHash = "sha256-+Jc3+3sN+muUk7yGZ0sDWR0xAwffZN14X0mcyF4EY20=";

  postInstall = ''
    install scripts/* -Dt $out/bin
  '';

  meta = {
    description = "Tool to control Kakoune editor from the command line";
    homepage = "https://github.com/vbauerster/kamp";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ erikeah ];
    mainProgram = "kamp";
    platforms = lib.platforms.linux;
  };
}
