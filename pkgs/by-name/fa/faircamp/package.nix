{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  makeWrapper,
  pkg-config,
  glib,
  libopus,
  vips,
  ffmpeg,
  callPackage,
  testers,
  faircamp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "faircamp";
  version = "1.7.0";

  src = fetchFromCodeberg {
    owner = "simonrepp";
    repo = "faircamp";
    rev = finalAttrs.version;
    hash = "sha256-r5r7vfTbMPjAqMg5f7L/YfSzlxZgrSFjO6WHO64wfIo=";
  };

  cargoHash = "sha256-11EcYZw6Dq0Ls1fhBYLlvvHeZtiaweg6JAGBmkX+acw=";

  buildFeatures = [ "libvips" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    glib
    libopus
    vips
  ];

  postInstall = ''
    wrapProgram $out/bin/faircamp \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  passthru.tests = {
    wav = callPackage ./test-wav.nix { };
    version = testers.testVersion { package = faircamp; };
  };

  meta = {
    description = "Self-hostable, statically generated bandcamp alternative";
    mainProgram = "faircamp";
    longDescription = ''
      Faircamp takes a directory on your disk - your Catalog - and from it
      produces a fancy-looking (and technically simple and completely static)
      website, which presents your music in a way similar to how popular
      commercial service bandcamp does it.

      You can upload the files faircamp generates to any webspace - no database
      and no programming language support (PHP or such) is required. If your
      webspace supports SSH access, faircamp can be configured to upload your
      website for you automatically, otherwise you can use FTP or whichever
      means you prefer to do that manually.
    '';
    homepage = "https://simonrepp.com/faircamp/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
