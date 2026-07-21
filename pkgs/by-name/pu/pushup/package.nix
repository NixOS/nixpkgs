{
  fetchFromGitHub,
  buildGoModule,
  lib,
  go,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "pushup";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "adhocteam";
    repo = "pushup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9ENXeVON2/Bt8oXnyVw+Vl0bPVPP7iFSyhxwc091ZIs=";
  };

  vendorHash = null;
  subPackages = ".";
  # Pushup doesn't need CGO so disable it.
  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];
  nativeBuildInputs = [ makeWrapper ];
  # The Go compiler is a runtime dependency of Pushup.
  allowGoReference = true;
  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = {
    description = "Web framework for Go";
    homepage = "https://pushup.adhoc.dev/";
    license = lib.licenses.mit;
    changelog = "https://github.com/adhocteam/pushup/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "pushup";
    maintainers = with lib.maintainers; [ paulsmith ];
  };
})
