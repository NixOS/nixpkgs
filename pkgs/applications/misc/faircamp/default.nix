{ lib
, stdenv
, rustPlatform
, fetchFromGitea
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
  version = "0.11.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "simonrepp";
    repo = "faircamp";
    rev = version;
    hash = "sha256-CD5wCvONlgNTXpFcCHCLdJ/lJsC2VTleKt9+ZX5znZo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "enolib-0.3.0" = "sha256-nw1nnIh2r4JFcUb3D21BcjeieDTYRIza8Lrq1yD+ZYQ=";
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
  ] ++ lib.optionals stdenv.isDarwin [
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
    description = "A self-hostable, statically generated bandcamp alternative";
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
