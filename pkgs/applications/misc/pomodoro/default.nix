{ lib, fetchFromGitHub, rustPlatform }:

let
  pname = "pomodoro";
  version = "0.1.0-git";
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit version;
  src = fetchFromGitHub {
    owner = "SanderJSA";
    repo = pname;
    rev = "c833b9551ed0b09e311cdb369cc8226c5b9cac6a";
    sha256 = "0x5apv5q0dhjrmjrmfzclsgd3ynyjd68llyk2yad8wa9hpanl3b4";
  };

  cargoSha256 = "0nwf2f6xywirz70kr5xxly5rbp493idfsv8y7bqgnwrp9y63v2q8";

  meta = with lib; {
    description = "A simple CLI pomodoro timer using desktop notifications written in Rust";
    homepage = "https://github.com/SanderJSA/Pomodoro";
    license = licenses.mit;
    maintainers = with maintainers; [ wamserma ];
  };
}
