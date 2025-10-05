{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
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
  version = "5.39.0";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    tag = "v${version}";
    hash = "sha256-R0IFIGDSpKxNmcDUMVdtKV+M3I8tglBhyHj5XXe2rjg=";
  };

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-llbBYO1dNPm+k8WEfao6qyDtQZbcmueNwFBuIpaMvFQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
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

  passthru.updateScript = nix-update-script { };

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
