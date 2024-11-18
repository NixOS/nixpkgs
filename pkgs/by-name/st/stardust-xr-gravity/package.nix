{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-gravity";
  version = "0-unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "gravity";
    rev = "96787ed3139717ea6061f6e259e9fed3e483274a";
    hash = "sha256-R87u7CX2n7iOOEEB3cHae2doqCn/skChHgeU+RNsHVk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tkWY+dLFDnyir6d0supR3Z202p5i4UewY+J66mL1x/o=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Utility to launch apps and stardust clients at an offet";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "gravity";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
