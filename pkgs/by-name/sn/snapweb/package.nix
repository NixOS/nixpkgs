{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "snapweb";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapweb";
    rev = "v${version}";
    hash = "sha256-ngtfmgaC+YioIqBXZ1dkNl3S7JqysdxxKNfi3qhYQAA=";
  };

  npmDepsHash = "sha256-bmCXbB0jQmsYLNlx92olYHudTNpKftbxEcFxtJIV9bQ=";

  # For 'sharp' dependency, otherwise it will try to build it
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ vips ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out/

    runHook postInstall
  '';

  meta = {
    description = "Web client for Snapcast";
    homepage = "https://github.com/badaix/snapweb";
    maintainers = with lib.maintainers; [ ettom ];
    license = lib.licenses.gpl3Plus;
  };
}
