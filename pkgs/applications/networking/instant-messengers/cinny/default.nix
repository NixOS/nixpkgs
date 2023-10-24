{ lib
, buildNpmPackage
, fetchFromGitHub
, writeText
, jq
, python3
, pkg-config
, pixman
, cairo
, pango
, stdenv
, darwin
, conf ? { }
}:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
buildNpmPackage rec {
  pname = "cinny";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-BFovEmT4RgdzlSYi1p0324PW7+2rvw3n5+jKWTV2FF4=";
  };

  npmDepsHash = "sha256-E+VBs66chBeiK40DZZ1hWTTISKaBN1RA+Uyr1iHqfus=";

  nativeBuildInputs = [
    jq
    python3
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreText
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with maintainers; [ abbe ashkitten ];
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
