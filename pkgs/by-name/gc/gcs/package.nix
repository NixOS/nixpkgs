{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, moreutils
, libGL
, libX11
, libXcursor
, libXrandr
, libXinerama
, libXi
, libXxf86vm
, mupdf
, fontconfig
, freetype
, stdenv
, darwin
, nix-update-script
}:

buildGoModule rec {
  pname = "gcs";
  version = "5.20.4";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = "v${version}";
    hash = "sha256-aoU2wRz2XB6+3e6am/dLjRbcDmWTjtDtTBwc6c4n3DE=";
  };

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-ee6qvwnUXtsBcovPOORfVpdndICtIUYe4GrP52V/P3k=";

  nativeBuildInputs = [ pkg-config moreutils ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libXxf86vm
    mupdf
    fontconfig
    freetype
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Carbon
    darwin.apple_sdk_11_0.frameworks.Cocoa
    darwin.apple_sdk_11_0.frameworks.Kernel
  ];

  # flags are based on https://github.com/richardwilkes/gcs/blob/master/build.sh
  flags = [ "-a" ];
  ldflags = [ "-s" "-w" "-X github.com/richardwilkes/toolbox/cmdline.AppVersion=${version}" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/gcs -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/richardwilkes/gcs/releases/tag/${src.rev}";
    description = "A stand-alone, interactive, character sheet editor for the GURPS 4th Edition roleplaying game system";
    homepage = "https://gurpscharactersheet.com/";
    license = lib.licenses.mpl20;
    mainProgram = "gcs";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # incompatible vendor/github.com/richardwilkes/unison/internal/skia/libskia_linux.a
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
