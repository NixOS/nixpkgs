{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-volume";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "smasher164";
    repo = "pw-volume";
    rev = "v${version}";
    sha256 = "sha256-r/6AAZKZgPYUGic/Dag7OT5RtH+RKgEkJVWxsO5VGZ0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MQ21pM8aSA/OnxGPVSEVVM6yF0CeX1T0VYN27tqZru8=";

  meta = with lib; {
    description = "Basic interface to PipeWire volume controls";
    homepage = "https://github.com/smasher164/pw-volume";
    changelog = "https://github.com/smasher164/pw-volume/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      astro
      figsoda
    ];
    platforms = platforms.linux;
    mainProgram = "pw-volume";
  };
}
