{
  stdenv,
  lib,
  fetchFromGitea,
  rustPlatform,
  makeWrapper,
  protobuf,
  darwin,
  imagemagick,
  ffmpeg,
  exiftool,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "pict-rs";
  version = "0.5.16";

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q0h+H3260CSpZemVuyaiwSHDi8yKXUX8Df9ih3IzAWo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JJB5d9N2/tu2SYudNNguQGocQdyFAMvBea/Q3V7pYOw=";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  postInstall = ''
    wrapProgram "$out/bin/pict-rs" \
        --prefix PATH : "${
          lib.makeBinPath [
            imagemagick
            ffmpeg
            exiftool
          ]
        }"
  '';

  passthru.tests = { inherit (nixosTests) pict-rs; };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simple image hosting service";
    mainProgram = "pict-rs";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ happysalada ];
  };
}
