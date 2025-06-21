{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "snapweb";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapweb";
    rev = "v${version}";
    hash = "sha256-vil7HzP2KtdhFCxW12ah3EN3PxTE0ypctGPQbHT4M98=";
  };

  npmDepsHash = "sha256-/gsdiAbxI2Wr1dzT8jGxoNx1hts1dVcTRKTj+5gFy0Y=";

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
