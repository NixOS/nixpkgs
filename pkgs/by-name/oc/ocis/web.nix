{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ocis-web";
  version = "v8.0.5";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "web";
    rev = version;
    hash = "sha256-hupdtK/V74+X7/eXoDmUjFvSKuhnoOtNQz7o6TLJXG4=";
  };

  nativeBuildInputs = [ pnpm.configHook ];

  buildInputs = [ nodejs ];

  buildPhase = ''
    pnpm build
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r dist/* $out/share/
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-m6yGqUmDor5273JsAlKs52Ug+bc3uhpI8F+MUhULAh4=";
  };

  meta = with lib; {
    license = [ licenses.agpl3Only ];
  };
}
