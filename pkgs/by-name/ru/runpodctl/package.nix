{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "runpodctl";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kv77st3dihVbIXBTjhmBl04h5HneMPo9+zMwAgnldak=";
  };

  vendorHash = "sha256-8Cdj5ZXmfooEh+MlaROjxVsAW6rZfPW7HNy86qnvAJA=";

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  meta = {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
})
