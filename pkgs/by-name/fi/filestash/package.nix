{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  brotli,
  libraw,
  giflib,
  libwebp,
  libjpeg,
  libpng,
  vips,
}:
let
  rev = "8935c628dabeabdeda2dd9d102e01102cceb24bf";
  buildDate = "20251205";
  goModuleName = "github.com/mickael-kerjean/filestash";
in
buildGoModule {
  pname = "filestash";
  version = "0-unstable-2025-12-05";

  src = fetchFromGitHub {
    inherit rev;

    owner = "mickael-kerjean";
    repo = "filestash";
    hash = "sha256-XRzNUbIS9/rcpq5q/b7DthClTDQtf4fA5dkzaJjjTs0=";
  };

  vendorHash = "sha256-AfgTt4dSUQ8YN+ekHRwmoGJSSMF9SQqS9K7kheQeNNA=";

  excludedPackages = [
    "server/generator"
    "server/plugin/plg_override_actiondelete" # Go source code error
    "server/plugin/plg_override_download" # Go source code error
  ];

  ldflags = [
    "-s -w -X ${goModuleName}/server/common.BUILD_REF=${rev} -X ${goModuleName}/server/common.BUILD_DATE=${buildDate}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    brotli.dev
    libraw.dev
    giflib
    libwebp
    libjpeg.dev
    libpng.dev
    vips.dev
  ];

  patches = [ ./pwd.patch ];

  postPatch = ''
    # Don't use static libs.
    for f in $(find . -type f -name '*.go'); do
      substituteInPlace "$f" --replace-quiet "-l:libwebp.a" "-lwebp"
      substituteInPlace "$f" --replace-quiet "-l:libjpeg.a" "-ljpeg"
      substituteInPlace "$f" --replace-quiet "-l:libpng.a" "-lpng"
      substituteInPlace "$f" --replace-quiet "-l:libraw.a" "-lraw"
      substituteInPlace "$f" --replace-quiet "-l:libz.a" "-lz"
    done

    # Constants set via ldflags.
    substituteInPlace server/common/constants.go --replace-fail "//go:generate go run ../generator/constants.go" ""
  '';

  doCheck = true;

  preBuild = ''
    go generate -x ./server/...
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/filestash
  '';

  meta = {
    mainProgram = "filestash";
    description = "Web app for managing and sharing files across different storage backends";
    homepage = "https://github.com/mickael-kerjean/filestash";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
}
