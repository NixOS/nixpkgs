{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  fuse3,
  brother-pe-core,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brother-pe-fuse";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "dlarochette";
    repo = "brother-pe-fuse";
    tag = finalAttrs.version;
    hash = "sha256-Yc1AZ5bykzQlLwpFHhzz0KfORf8hfbcMbIrSqSeAAyU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    brother-pe-core
    fuse3
  ];

  postPatch = ''
    patchShebangs --build tests
  '';

  # The real mount test skips itself (exit code 77) without /dev/fuse, as in the sandbox.
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Brother embroidery card mounted as a read-only folder with generated previews";
    longDescription = ''
      Mounts the card inserted in the Brother USB embroidery card writer
      (04f9:2100), or a saved card image, as a read-only FUSE folder: card
      information, raw image and, for each design, PES, DST and SVG files and a
      PNG preview. On NixOS, add brother-pe-core to services.udev.packages for
      access to the reader.
    '';
    homepage = "https://gitlab.com/dlarochette/brother-pe-fuse";
    changelog = "https://gitlab.com/dlarochette/brother-pe-fuse/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dlarochette ];
    mainProgram = "brother-pe-fuse";
    platforms = lib.platforms.linux;
  };
})
