{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "snapweb";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapweb";
    rev = "v${version}";
    hash = "sha256-rrJmuTFk2dC+GqYmBZ+hu5hx1iknAgSWjr22S7bfmEE=";
  };

  npmDepsHash = "sha256-n1MmU9zHyuEqtQSfYpQ+0hDM0z6ongcFsGyikPMyNSU=";

  # For 'sharp' dependency, otherwise it will try to build it
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ vips ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web client for Snapcast";
    homepage = "https://github.com/badaix/snapweb";
    maintainers = with maintainers; [ ettom ];
    license = licenses.gpl3Plus;
  };
}
