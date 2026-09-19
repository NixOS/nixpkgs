{
  fetchFromGitHub,
  help2man,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediaextract";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "panzi";
    repo = "mediaextract";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTCArtei6bDdEHuVqdQBfTJUZxOw63zdPFXFvWGxcl8=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [
    "CC=cc"
    "CXX=C++"
    "PREFIX=$(out)"
    "TARGET=nix" # ignore special casing in Makefile since cc-wrapper handles it
  ];

  # Drop shell-out for TARGET in Makefile
  patchPhase = ''
    runHook prePatch

    sed -i '2d' Makefile

    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfigure

    make TARGET=nix builddir

    runHook postConfigure
  '';

  nativeBuildInputs = [
    help2man
  ];

  meta = {
    description = "Extracts media files (AVI, Ogg, Wave, PNG, ...) that are embedded within other files";
    homepage = "http://panzi.github.io/mediaextract/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samasaur ];
    platforms = lib.platforms.all;
    mainProgram = "mediaextract";
  };
})
