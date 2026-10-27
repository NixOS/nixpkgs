{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libx11,
  libxinerama,
}:

let
  rpathLibs = [
    libxinerama
    libx11
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leftwm";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    tag = finalAttrs.version;
    hash = "sha256-Ox4eOE+RmyKfReSjeMGSYZCEC67/HIE+uY830gm4G94=";
  };

  cargoHash = "sha256-Y/ts0WOhxPDv8B3/kk6+PwS6Tjpf0gjjnjzLDrp3Vk0=";

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done

    install -D -m 0555 leftwm/doc/leftwm.1 $out/share/man/man1/leftwm.1
  '';

  dontPatchELF = true;

  meta = {
    description = "Tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      vuimuich
      yanganto
    ];
    changelog = "https://github.com/leftwm/leftwm/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "leftwm";
  };
})
