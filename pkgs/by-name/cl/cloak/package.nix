{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cloak";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "evansmurithi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pd2aorsXdHB1bs609+S5s+WV5M1ql48yIKaoN8SEvsg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PAZOenugZrKYIP7zzxozerjkauwg7VN0mAlex0WPttQ=";

  meta = with lib; {
    homepage = "https://github.com/evansmurithi/cloak";
    description = "Command-line OTP authenticator application";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "cloak";
  };
}
