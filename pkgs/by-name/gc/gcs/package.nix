{
  lib,
  stdenv,
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
  apple-sdk_11,
}:

buildGoModule rec {
  pname = "gcs";
  version = "5.28.1";

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

    hash = "sha256-ArJ+GveG2Y1PYeCuIFJoQ3eVyqvAi4HEeAEd4X03yu4=";
  };

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-EmAGkQ+GHzVbSq/nPu0awL79jRmZuMHheBWwanfEgGI=";

  frontend = buildNpmPackage {
    name = "${pname}-${version}-frontend";

    inherit src;
    sourceRoot = "${src.name}/server/frontend";
    npmDepsHash = "sha256-LqOH3jhp4Mx7JGYSjF29kVUny3xNn7oX0qCYi79SH4w=";

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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
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
