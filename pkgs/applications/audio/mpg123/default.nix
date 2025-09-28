{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkg-config,
  libOnly ? false, # whether to build only the library
  withAlsa ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  withPulse ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  withCoreAudio ? stdenv.hostPlatform.isDarwin,
  withJack ? stdenv.hostPlatform.isUnix,
  jack,
  withConplay ? !stdenv.hostPlatform.isWindows,
  perl,
  writeScript,
}:

assert withConplay -> !libOnly;

stdenv.mkDerivation rec {
  pname = "${lib.optionalString libOnly "lib"}mpg123";
  version = "1.33.2";

  src = fetchurl {
    url = "mirror://sourceforge/mpg123/mpg123-${version}.tar.bz2";
    hash = "sha256-LFT6u/ppbc6PmxN8jvekKaBh+P5jPNfQpRGAmFXywhk=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ]
  ++ lib.optional withConplay "conplay";

  nativeBuildInputs = lib.optionals (!libOnly) (
    lib.optionals withConplay [ makeWrapper ] ++ lib.optionals (withPulse || withJack) [ pkg-config ]
  );

  buildInputs = lib.optionals (!libOnly) (
    lib.optionals withConplay [ perl ]
    ++ lib.optionals withAlsa [ alsa-lib ]
    ++ lib.optionals withPulse [ libpulseaudio ]
    ++ lib.optionals withCoreAudio [
    ]
    ++ lib.optionals withJack [ jack ]
  );

  configureFlags =
    lib.optionals (!libOnly) [
      "--with-audio=${
        lib.strings.concatStringsSep "," (
          lib.optional withJack "jack"
          ++ lib.optional withPulse "pulse"
          ++ lib.optional withAlsa "alsa"
          ++ lib.optional withCoreAudio "coreaudio"
          ++ [ "dummy" ]
        )
      }"
    ]
    ++ lib.optional (stdenv.hostPlatform ? mpg123) "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  enableParallelBuilding = true;

  postInstall = lib.optionalString withConplay ''
    mkdir -p $conplay/bin
    mv scripts/conplay $conplay/bin/
  '';

  preFixup = lib.optionalString withConplay ''
    patchShebangs $conplay/bin/conplay
  '';

  postFixup = lib.optionalString withConplay ''
    wrapProgram $conplay/bin/conplay \
      --prefix PATH : $out/bin
  '';

  passthru = {
    updateScript = writeScript "update-mpg123" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<a href="download/mpg123-1.32.6.tar.bz2">'
      new_version="$(curl -s https://mpg123.org/download.shtml |
          pcregrep -o1 '<a href="download/mpg123-([0-9.]+).tar.bz2">')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "https://mpg123.org";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ftrvxmtrx ];
    platforms = platforms.all;
  };
}
