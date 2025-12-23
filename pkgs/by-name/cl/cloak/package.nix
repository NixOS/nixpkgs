{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cloak";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "evansmurithi";
    repo = "cloak";
    tag = "v${version}";
    hash = "sha256-Pd2aorsXdHB1bs609+S5s+WV5M1ql48yIKaoN8SEvsg=";
  };

  cargoHash = "sha256-PAZOenugZrKYIP7zzxozerjkauwg7VN0mAlex0WPttQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/evansmurithi/cloak";
    description = "Command-line OTP authenticator application";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    mainProgram = "cloak";
  };
}
