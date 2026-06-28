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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pict-rs";
  version = "0.5.23";

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = "pict-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9FEVqN/j+VCK0CihpfNXSp1JZ3G7/mB5R+NJKQQtwc0=";
  };

  cargoHash = "sha256-LYCLGu569sJkEIm6oHWebIH4+AX7cGnRzPn7U29LNuQ=";

  env = {
    # needed for internal protobuf c wrapper library
    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";
  };

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

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simple image hosting service";
    mainProgram = "pict-rs";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
    license = with lib.licenses; agpl3Plus;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
