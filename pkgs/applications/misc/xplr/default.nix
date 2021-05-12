{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "00kmmdwwf9cll25bkszgin2021ggf9b28jlcpicin5kgw4iwlhkj";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  cargoSha256 = "1j43vwb885h355wdmjijz1qpkqn1dmb93hwi6vc035vkbbxs1g4r";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
