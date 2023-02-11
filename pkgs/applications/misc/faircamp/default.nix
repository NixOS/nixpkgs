{ lib
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
}:

rustPlatform.buildRustPackage {
  pname = "faircamp";
  version = "unstable-2022-12-28";

  # TODO when switching to a stable release, use fetchFromGitea and add a
  # version test. Meanwhile, fetchgit is used to make unstableGitUpdater work.
  src = fetchgit {
    url = "https://codeberg.org/simonrepp/faircamp.git";
    rev = "c77fd779cea6daecbac9a9beea65c1dc1ac56bc4";
    sha256 = "sha256-Tl3T/IoBIhYCNDEYT6cV1UyksDkoEDydBjYM9yzT4VQ=";
  };

  cargoHash = "sha256-20rtE8+LLDz97yvk0gKoUielsGZXEEOu2pfShf2WvHA=";

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
    homepage = "https://codeberg.org/simonrepp/faircamp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
