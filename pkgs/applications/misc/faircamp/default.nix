{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, fetchpatch
, makeWrapper
, pkg-config
, glib
, libopus
, vips
, ffmpeg
, callPackage
, darwin
, testers
, faircamp
}:

rustPlatform.buildRustPackage rec {
  pname = "faircamp";
  version = "0.15.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "simonrepp";
    repo = "faircamp";
    rev = version;
    hash = "sha256-TMN4DLur61bJAPp2kahBAAjf2lto62X/7rhC88nhISg=";
  };

  patches = [
    # Fix build error in tests
    (fetchpatch {
      url = "https://codeberg.org/simonrepp/faircamp/commit/7240dd707f3669d49e755088393d27369ca368c2.patch";
      hash = "sha256-Ec75Gte2zUp/q912keLdYXUse60QirTQ+DkSaCwEboQ=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "enolib-0.4.2" = "sha256-FJuWKcwjoi/wKfTzxghobNWblhnKRdUvHOejhpCF7kY=";
    };
  };

  buildFeatures = [ "libvips" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    glib
    libopus
    vips
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    wrapProgram $out/bin/faircamp \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  passthru.tests = {
    wav = callPackage ./test-wav.nix { };
    version = testers.testVersion { package = faircamp; };
  };

  meta = with lib; {
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
