{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sBstFz7cYfwVQpDZeC3wPjzbKU5zQzmnhiWNqiCda1k=";
  };

  cargoHash = "sha256-P6riJgnEe+bNP3cUKNCfIkgKM44XGYSDADnU6w7CFDA=";

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [
      figsoda
      lumi
    ];
    platforms = platforms.linux;
    mainProgram = "shotgun";
  };
}
