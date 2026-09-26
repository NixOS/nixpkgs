{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

buildGoModule (finalAttrs: {
  pname = "bbctl";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3vfZmnjPAdTNejlNE0m2Kd63ZRCtsZgTpz5YEBVkC3I=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  vendorHash = "sha256-X4DbDfiu1VAhFAUT+VH5T4GpeofjhLDdoKwyNVBA9A4=";

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
