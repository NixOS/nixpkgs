{
  buildNpmPackage,
  lib,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage rec {
  pname = "snapweb";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapweb";
    rev = "v${version}";
    hash = "sha256-7W7rvJPVcRtXcQt+wWAvrl0DOIh7zEfXZdFDcH23/ls=";
  };

  npmDepsHash = "sha256-STZ/+vmiUAOZ8+yeaFg+428pZ/iZZXXUeGx6gLmnDQ8=";

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
