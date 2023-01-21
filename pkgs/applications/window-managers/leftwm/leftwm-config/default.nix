{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "leftwm-config";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = pname;
    rev = version;
    sha256 = "sha256-hWxyzgWWh6CBxpbbXfd888Q70cCZQ9FESDijOSXtdZA=";
  };

  cargoSha256 = "sha256-NfBteoknxveIGrpSuDe70LLnGvN3nb9gvbVbbwsYD4A=";

  patches = [ ./0001-rm-unstable-is-some-with-feature.patch ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A little satellite utility for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-config";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yanganto ];
  };
}
