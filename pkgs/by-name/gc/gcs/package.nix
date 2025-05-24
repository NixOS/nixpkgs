{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libGL,
  libX11,
  libXcursor,
  libXrandr,
  libXinerama,
  libXi,
  libXxf86vm,
  mupdf,
  fontconfig,
  freetype,
}:

buildGoModule rec {
  pname = "gcs";
  version = "5.35.0";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    tag = "v${version}";

    hash = "sha256-qS0j838sjzdxRtvnah2nQ6tJzd7SVl5Fwfkcc6VP+/8=";
  };

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-EI2jbIYkjhINTY0FcFHsN1mQM6VlkvZeekDSzAXbG3c";

  nativeBuildInputs = [
    pkg-config
    makeDesktopItem
  ];

  buildInputs =
    [
      mupdf
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libX11
      libXcursor
      libXrandr
      libXinerama
      libXi
      libXxf86vm
      fontconfig
      freetype
    ];

  # flags are based on https://github.com/richardwilkes/gcs/blob/master/build.sh
  flags = [ "-a" ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/richardwilkes/toolbox/cmdline.AppVersion=${version}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/gcs -t $out/bin
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/richardwilkes/gcs/releases/tag/v${version}";
    description = "Stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    license = lib.licenses.mpl20;
    mainProgram = "gcs";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # incompatible vendor/github.com/richardwilkes/unison/internal/skia/libskia_linux.a
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
