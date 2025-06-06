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

  patches = [
    # on Linux the program generates its .desktop file and icons and mimetype stuff on the fly during runtime
    # and places them into ~/.local/share
    # this patch makes it so that this is not done during runtime
    # but instead exposes a way to generate them during build time
    ./helper-files-in-store.patch
  ];

  postPatch = ''
    substituteInPlace ux/platform_linux.go \
      --replace-fail "@out@" "$out"
  '';

  modPostBuild = ''
    chmod +w vendor/github.com/richardwilkes/pdf
    sed -i 's|-lmupdf[^ ]* |-lmupdf |g' vendor/github.com/richardwilkes/pdf/pdf.go
  '';

  vendorHash = "sha256-EI2jbIYkjhINTY0FcFHsN1mQM6VlkvZeekDSzAXbG3c=";

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
    ];

  # flags are based on https://github.com/richardwilkes/gcs/blob/master/build.sh
  flags = [ "-a" ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/richardwilkes/toolbox/cmdline.AppVersion=${version}"
  ];

  installPhase =
    ''
      runHook preInstall
      install -Dm755 $GOPATH/bin/gcs -t $out/bin
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      go run -v --mod=vendor nixpkgs/main.go

      # we patched out mimetype icon generation, because it requires a GUI
      # instead we install the pre-rendered pngs
      for f in pkgicons/*_doc.png; do
        id=$(basename "$f" _doc.png)
        install -Dm644 "$f" "$out/share/icons/hicolor/256x256/mimetypes/application-x-gcs-$id.png"
      done
    ''
    + ''
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
