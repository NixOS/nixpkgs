{
  lib,
  stdenv,
  fetchFromGitLab,
  alsa-lib,
  autoreconfHook,
  ffmpeg,
  fftw,
  glib,
  imagemagick,
  jansson,
  lebiniou-data,
  libcaca,
  libjack2,
  liblo,
  libpulseaudio,
  libsndfile,
  lndir,
  makeWrapper,
  orcania,
  perl,
  pkg-config,
  SDL2,
  ulfius,
  xdg-utils,
  yder,

  # Le Biniou POSTs usage statistics, hostname included, to stats.biniou.net.
  enableTelemetry ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lebiniou";
  version = "3.67.0";

  src = fetchFromGitLab {
    owner = "lebiniou";
    repo = "lebiniou";
    tag = "version-${finalAttrs.version}";
    hash = "sha256-lfGoUkXHDVo0ifLrQUiiVXl0hDz1Tp5J7KJkZ0IVb9w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    lndir
    makeWrapper
    perl # pod2man, for the man page
    pkg-config
  ];

  buildInputs = [
    SDL2
    alsa-lib
    ffmpeg
    fftw
    glib
    imagemagick
    jansson
    libcaca
    libjack2
    liblo
    libpulseaudio
    libsndfile
    orcania
    ulfius
    yder
  ];

  # Data is resolved below the compiled-in $out/share/lebiniou, and the web
  # interface path has no runtime override, so merge lebiniou-data in.
  postInstall = ''
    lndir -silent ${lebiniou-data}/share/lebiniou $out/share/lebiniou

    # The web interface is opened with `system("xdg-open ...")`. Suffix, so a
    # desktop session's own xdg-open keeps precedence.
    wrapProgram $out/bin/lebiniou \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      ${lib.optionalString (!enableTelemetry) "--add-flags --no-statistics"}
  '';

  meta = {
    description = "User-friendly, powerful music visualization / VJing tool";
    homepage = "https://biniou.lenain.info/";
    changelog = "https://gitlab.com/lebiniou/lebiniou/-/blob/version-${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "lebiniou";
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    platforms = lib.platforms.linux;
  };
})
