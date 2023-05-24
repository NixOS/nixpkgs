{ lib
, buildNpmPackage
, fetchFromGitHub
, nodePackages
}:

buildNpmPackage rec {
  pname = "fantasia-archive";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "Elvanos";
    repo = "fantasia-archive";
    rev = "v${version}";
    hash = "sha256-LOC/LY8ZG9Mtm7nTqqJ0s125NCrY3p3BZ2aw+hClIUg=";
  };

  nativeBuildInputs = [ nodePackages.node-gyp-build ];

  npmDepsHash = "sha256-6GWEnU5xQPfQbRita4cYR4h6GOgwozj8Yt3VJopU8jU=";

  meta = with lib; {
    description = "100% free, powerful & feature-rich offline worldbuilding tool that runs on your computer!";
    homepage = "https://fantasiaarchive.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ elnudev ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
