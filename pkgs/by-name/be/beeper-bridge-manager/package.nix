{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "bbctl";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sajgG0Ep6CDlAQRNzgRFHDMX3N1PyCZr6DI+3EkZxzg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  vendorHash = "sha256-U3RwcMAeLVob4K5YAM5w4rqNA2hSX1uIXwFmpYKxzIU=";

  postInstall = ''
    wrapProgram $out/bin/bbctl \
      --prefix PATH : ${python3}/bin
  '';

  meta = {
    description = "Tool for running self-hosted bridges with the Beeper Matrix server";
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "bbctl";
    changelog = "https://github.com/beeper/bridge-manager/releases/tag/v${finalAttrs.version}";
  };
})
