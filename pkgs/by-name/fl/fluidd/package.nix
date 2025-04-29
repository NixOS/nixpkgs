{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  replaceVars,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "fluidd";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "fluidd-core";
    repo = "fluidd";
    tag = "v${version}";
    hash = "sha256-7LnpGmZKY6zROaKxyZJiWuNuax5rsehL2feCgRhRhUg=";
  };

  patches = [
    (replaceVars ./hardcode-version.patch {
      inherit version;
    })
  ];

  npmDepsHash = "sha256-5hIj9rqioMYx3BgrRHfEqSqw+cTFg6MKjjSNy7zg/Jg=";

  installPhase = ''
    mkdir -p $out/share/fluidd
    cp -r dist $out/share/fluidd/htdocs
  '';

  passthru.tests = { inherit (nixosTests) fluidd; };

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
