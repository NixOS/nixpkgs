{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "hexo";
  version = "7.0.0-rc1";

  src = fetchFromGitHub {
    owner = "hexojs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/eAGalUFskQ5wB1R9MfgiKQhyvgIyfdTzWabtMizd7g=";
  };

  npmDepsHash = "sha256-/G5KNP/gvQovELbfksLwZmpDW7FIxdy/0dvCPA0Zlk0=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  installPhase = ''
    mkdir -p $out
    cp -r bin/ $out/
    cp -r node_modules/ $out/
  '';

  meta = with lib; {
    description = "A fast, simple and powerful blog framework, powered by Node.js";
    homepage = "https://hexo.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ jedsek ];
  };
}
