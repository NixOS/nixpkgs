{
  fetchzip,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "swiftdefaultapps";
  version = "2.0.1";

  # Fetch the release which includes the prebuild binary since this is a Swift project and nixpkgs
  # doesn't currently have the ability to build Swift projects.
  src = fetchzip {
    url = "https://github.com/Lord-Kamina/SwiftDefaultApps/releases/download/v${version}/SwiftDefaultApps-v${version}.zip";
    stripRoot = false;
    sha256 = "sha256-0HsHjZBPUzmdvHy7E9EdZj6zwaXjSX2u5aj8pij0u3E=";
  };

  installPhase = ''
    runHook preInstall
    install -D './swda' "$out/bin/swda"
    runHook postInstall
  '';

  meta = with lib; {
    description = "View and change the default application for url schemes and UTIs";
    homepage = "https://github.com/Lord-Kamina/SwiftDefaultApps";
    license = licenses.beerware;
    maintainers = [ maintainers.malo ];
    platforms = platforms.darwin;
    mainProgram = "swda";
  };
}
