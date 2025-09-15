{
  fetchFromGitHub,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  lib,
  libjpeg,
  libz,
  mujs,
  mupdf,
  openjpeg,
  pkg-config,
  stdenv,
  zig_0_14,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fancy-cat";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "freref";
    repo = "fancy-cat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P7vipg8nWgBLAHvQ2HzEg4MnPhWvoxl9eQZkhQMW5hQ=";
  };

  patches = [ ./0001-changes.patch ];

  nativeBuildInputs = [
    zig_0_14.hook
    pkg-config
  ];

  zigBuildFlags = [ "--release=fast" ];

  buildInputs = [
    mupdf
    harfbuzz
    freetype
    jbig2dec
    libjpeg
    openjpeg
    gumbo
    mujs
    libz
  ];

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-G7UJdSfMl+bomBCZ6bLWnS1wpbPL+iSY/2QujtMJHpI=";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PDF viewer for terminals using the Kitty image protocol";
    homepage = "https://github.com/freref/fancy-cat";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ciflire ];
    mainProgram = "fancy-cat";
    inherit (zig_0_14.meta) platforms;
  };
})
