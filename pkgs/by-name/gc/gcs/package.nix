{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  cacert,
  unzip,
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
  stdenv,
  darwin,
}:

buildGoModule rec {
  pname = "gcs";
  version = "5.27.0";

  src = fetchFromGitHub {
    owner = "richardwilkes";
    repo = "gcs";
    rev = "refs/tags/v${version}";

    nativeBuildInputs = [
      cacert
      unzip
    ];

    # also fetch pdf.js files
    # note: the version is locked in the file
    postFetch = ''
      cd $out/server/pdf
      substituteInPlace refresh-pdf.js.sh \
          --replace-fail '/bin/rm' 'rm'
      . refresh-pdf.js.sh
    '';

    hash = "sha256-QVkyemBQ7RrV3dpP3n7Pg0XljdxWtCphZIj2T77nKtU=";
  };

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-+vCc1g5noAl/iwEYhNZJYPiScKqKGKlsuruoUO/4tiU=";

  frontend = buildNpmPackage {
    name = "${pname}-${version}-frontend";

    inherit src;
    sourceRoot = "${src.name}/server/frontend";
    npmDepsHash = "sha256-VWTJg/pluRYVVBDiJ+t2uhyodRuIFfHpzCZMte1krDM=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/dist
      runHook postInstall
    '';
  };

  postPatch = ''
    cp -r ${frontend}/dist server/frontend/dist
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Carbon
      darwin.apple_sdk_11_0.frameworks.Cocoa
      darwin.apple_sdk_11_0.frameworks.Kernel
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
