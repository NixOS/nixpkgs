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
, nix-update-script
}:

buildGoModule rec {
  pname = "gcs";
  version = "5.20.3";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = "v${version}";
    hash = "sha256-BdoKyK+V/lMp27CorUWjilZDZzFiv9z7kyq3wWVehzk=";
  };

  vendorHash = "sha256-Y5iyOMOtfGnJjxv2qLIOAMJmv6eqBsIFe870SyX/jtA=";

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
  ];

  preBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  # flags are based on https://github.com/richardwilkes/gcs/blob/master/build.sh
  flags = [ "-a -trimpath" ];
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
  };
}
