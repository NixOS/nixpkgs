{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "choose";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = "choose";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nqL8CAnpqOaecC6vHlCtVXFRO0OAGZAn12TdOM5iUFA=";
  };

  cargoHash = "sha256-NVpkCs1QY2e+WiI9nk1uz/j3pOtsJpMwgAMspB6Bs1E=";

  meta = {
    description = "Human-friendly and fast alternative to cut and (sometimes) awk";
    mainProgram = "choose";
    homepage = "https://github.com/theryangeary/choose";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sohalt ];
  };
})
