{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  libcosmicAppHook,
  glib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-files";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-UwQwZRzOyMvLRRmU2noxGrqblezkR8J2PNMVoyG0M0w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-me/U4LtnvYtf77qxF2Z1ncHRVOLp3inDVlwnCjwlj08=";

  env = {
    VERGEN_GIT_COMMIT_DATE = "2024-08-05";
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  buildInputs = [ glib ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
  ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
})
