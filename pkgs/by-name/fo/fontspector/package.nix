{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "fontspector";
  version = "1.5.1-git";

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "fontspector";
    rev = "e4722fef242bc3554263a87e2b67599312e4dc14";
    hash = "sha256-s3w+uWvi+S0FP7yi6mCSDhCmJsJCTBK9eFm2NSU3SM0=";
  };

  cargoHash = "sha256-5C/u25SYNAdPjvJ8Lb2s6EBuHR593eYe5Bps5hwiC4s=";

  patches = [ ./fontspector-offline.patch ];

  postPatch = ''
    cp ${./fontspector-checkapi-src/script_tags.rs} fontspector-checkapi/src/script_tags.rs
    cp ${./fontspector-checkapi-src/language_tags.rs} fontspector-checkapi/src/language_tags.rs
  '';

  cargoBuildFlags = [ "-p" "fontspector" ];
  cargoTestFlags = [ "-p" "fontspector" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  meta = with lib; {
    description = "Skrifa/Read-Fonts-based font QA tool (successor to fontbakery)";
    homepage = "https://github.com/fonttools/fontspector";
    license = licenses.asl20;
    maintainers = with maintainers; [ ]; # Add your maintainer entry
    mainProgram = "fontspector";
    platforms = platforms.unix;
  };
}
