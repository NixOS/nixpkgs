{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imageworsener";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "jsummers";
    repo = "imageworsener";
    rev = finalAttrs.version;
    hash = "sha256-1f5x8Ph994Kkjo38NudXL+UF0fpR8BmZfaGPxc8RENU=";
  };

  patches = [
    # Fix tests not failing even when they should.
    # https://github.com/jsummers/imageworsener/pull/46
    (fetchpatch2 {
      url = "https://github.com/jsummers/imageworsener/commit/91c7c79d86f55920193d17a7b87631b14ac7779f.patch?full_index=1";
      hash = "sha256-8vxht0FiQFOdglwaO0ZQpg5BNYXXHROkznZ+Caxm/v0=";
    })
  ];

  postPatch = ''
    patchShebangs tests/runtest

    # JPEG tests fail due to libjpeg-turbo differences.
    sed -i '/\.jpg/d' tests/runtest
    rm tests/expected/*.jpg
  '';

  postInstall = ''
    mkdir -p $out/share/doc/imageworsener
    cp readme.txt technical.txt $out/share/doc/imageworsener
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    zlib
    libpng
    libjpeg
    libwebp
  ];

  strictDeps = true;

  doCheck = true;

  enableParallelBuilding = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Raster image scaling and processing utility";
    longDescription = ''
      ImageWorsener is a cross-platform command-line utility and library for
      image scaling and other image processing. It has full support for PNG,
      JPEG, BMP formats, experimental support for WebP, read-only support for
      GIF, and limited support for some other image formats. It’s not as
      fast or memory-efficient as some utilities, but it’s very accurate.
    '';
    homepage = "https://entropymine.com/imageworsener/";
    changelog = "${finalAttrs.src.meta.homepage}/blob/${finalAttrs.src.rev}/changelog.txt";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.emily
      lib.maintainers.smitop
    ];
    mainProgram = "imagew";
    platforms = lib.platforms.all;
  };
})
