{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "snapweb";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapweb";
    rev = "v${version}";
    hash = "sha256-vrPmN06dLEoz7vFrH8kOdudg9FQcd1BpMWKpU6kZrzE=";
  };

  npmDepsHash = "sha256-VDGoZ6XgVtr7xePXmfW4Vk6iTZv1HRx7bjsS+Qauz3U=";

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
