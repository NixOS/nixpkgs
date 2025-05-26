{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  bc,
  libnotify,
  feh,
  grim,
  imagemagick,
  slurp,
  wl-clipboard,
  xcolor,

  waylandSupport ? true,
  x11Support ? true,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "farge";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "farge";
    rev = "2ff6669e2350644d4f0b1bd84526efe5eae3c302";
    hash = "sha256-vCMuFMGcI4D4EzbSsXeNGKNS6nBFkfTcAmSzb9UMArc=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Ensure the following programs are found within $PATH
  wrapperPath = lib.makeBinPath (
    [
      bc
      feh
      libnotify # notify-send
      # Needed to fix font rendering issue in imagemagick
      (imagemagick.override { ghostscriptSupport = true; })
    ]
    ++ lib.optionals waylandSupport [
      grim
      slurp
      wl-clipboard
    ]
    ++ lib.optional x11Support xcolor
  );

  installPhase = ''
    runHook preInstall
    install -Dm755 farge $out/bin/farge
    wrapProgram $out/bin/farge \
      --prefix PATH : "${finalAttrs.wrapperPath}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "View the color value of a specific pixel on your screen";
    homepage = "https://github.com/sdushantha/farge";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      jtbx
      justinlime
    ];
    mainProgram = "farge";
  };
})
