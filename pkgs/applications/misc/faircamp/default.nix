{ lib
, stdenv
, rustPlatform
, fetchgit
, makeWrapper
, pkg-config
, glib
, libopus
, vips
, ffmpeg
, callPackage
, unstableGitUpdater
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "faircamp";
  version = "unstable-2023-04-10";

  # TODO when switching to a stable release, use fetchFromGitea and add a
  # version test. Meanwhile, fetchgit is used to make unstableGitUpdater work.
  src = fetchgit {
    url = "https://codeberg.org/simonrepp/faircamp.git";
    rev = "21f775dc35a88c54015694f9757e81c97fa860ea";
    hash = "sha256-aMSMMIGfoiqtg8Dj8QiCbUE40OKQXMXt4hvlvbXQLls=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "enolib-0.1.0" = "sha256-0+T8RRQnqbIiIup/aDJgvxeV8sRV4YrlA9JVbQxMfF0=";
    };
  };

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

  passthru.tests.wav = callPackage ./test-wav.nix { };

  passthru.updateScript = unstableGitUpdater { };

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
