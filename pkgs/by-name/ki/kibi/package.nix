{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kibi";
  version = "0.3.0";

  cargoHash = "sha256-gXkwqmmFGNEJY7an3KWlRuLL5WuCH4P0n7BrLNsZ9/A=";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6uDpTQ97eNgM1lCiYPWS5QPxMNcPF3Ix14VaGiTY4Kc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 syntax.d/* -t $out/share/kibi/syntax.d
    install -Dm644 kibi.desktop -t $out/share/applications
    install -Dm0644 assets/logo.svg $out/share/icons/hicolor/scalable/apps/kibi.svg
    wrapProgram $out/bin/kibi --prefix XDG_DATA_DIRS : "$out/share"
  '';

  meta = {
    description = "Text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ robertodr ];
    mainProgram = "kibi";
  };
})
