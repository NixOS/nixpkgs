{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kibi";
  version = "0.3.1";

  cargoHash = "sha256-IF7pcatGJDcwTmBziB8hVWJkleoV+pXXRQnbYfQtBJE=";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EXobpuVob4RD37LK0RlpCGXACfemm+e+JczYYPNDhrc=";
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
