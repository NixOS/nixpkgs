{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-volume";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "smasher164";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r/6AAZKZgPYUGic/Dag7OT5RtH+RKgEkJVWxsO5VGZ0=";
  };

  cargoHash = "sha256-srwbrMBUJz/Xi+Hk2GY9oo4rcTfKl/r146YWSSx6dew=";

  meta = with lib; {
    description = "Basic interface to PipeWire volume controls";
    homepage = "https://github.com/smasher164/pw-volume";
    changelog = "https://github.com/smasher164/pw-volume/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ astro figsoda ];
    platforms = platforms.linux;
    mainProgram = "pw-volume";
  };
}
