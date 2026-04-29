{
  lib,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  rustPlatform,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "retoc";
  version = "0.1.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trumank";
    repo = "retoc";
    tag = "v${version}";
    hash = "sha256-rpDBDViype47oIPfTwlsjRlF9rLDIu3NSGGV46YP8jQ=";
  };

  cargoHash = "sha256-jevIk0XXQbGMA8M94tti8UuXlpcjagpcPCB7PXKewLE=";

  oodleLib = fetchurl {
    url = "https://raw.githubusercontent.com/WorkingRobot/OodleUE/a4c95b32ab07c3f35dce7e7c52b0f8cbfd3a7765/Engine/Source/Programs/Shared/EpicGames.Oodle/Sdk/2.9.10/linux/lib/liboo2corelinux64.so.9";
    hash = "sha256-7X6Y9wvhJUqAZE79OuRC/2H4VKL+neuwuXi5UomITpw=";
  };

  cargoBuildFlags = [
    "-p"
    "retoc_cli"
  ];
  cargoTestFlags = [
    "-p"
    "retoc_cli"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm444 ${oodleLib} "$out/bin/liboo2corelinux64.so.9"
    wrapProgram "$out/bin/retoc" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unreal Engine IoStore CLI packing and unpacking tool";
    homepage = "https://github.com/trumank/retoc";
    changelog = "https://github.com/trumank/retoc/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      unfreeRedistributable
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "retoc";
    platforms = [ "x86_64-linux" ];
  };
}
