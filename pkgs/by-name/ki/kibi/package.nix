{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.3.0";

  cargoHash = "sha256-gXkwqmmFGNEJY7an3KWlRuLL5WuCH4P0n7BrLNsZ9/A=";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "sha256-6uDpTQ97eNgM1lCiYPWS5QPxMNcPF3Ix14VaGiTY4Kc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 syntax.d/* -t $out/share/kibi/syntax.d
    wrapProgram $out/bin/kibi --prefix XDG_DATA_DIRS : "$out/share"
  '';

  meta = with lib; {
    description = "Text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
    mainProgram = "kibi";
  };
}
