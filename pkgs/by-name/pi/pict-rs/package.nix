{
  stdenv,
  lib,
  fetchFromGitea,
  rustPlatform,
  makeWrapper,
  protobuf,
  imagemagick,
  ffmpeg,
  exiftool,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "pict-rs";
  version = "0.5.19";

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = "pict-rs";
    rev = "v${version}";
    sha256 = "sha256-ifuN3Kb7Hhq8H/eoZcumO5yyrxOCA+nWQQvAdFk7w2Q=";
  };

  cargoHash = "sha256-wZRWusETLl32BJy5lza4Bvix500VkpXLUpQb5aO8yJ0=";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [ makeWrapper ];

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simple image hosting service";
    mainProgram = "pict-rs";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
<<<<<<< HEAD
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ happysalada ];
=======
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ happysalada ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
