{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, makeWrapper
, alsa-lib
, lame
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "downonspot";
  version = "unstable-2021-10-13";

  src = fetchFromGitHub {
    owner = "oSumAtrIX";
    repo = "DownOnSpot";
    rev = "9d78ea2acad4dfe653a895a1547ad0abe7c5b47a";
    sha256 = "03g99yx9sldcg3i6hvpdxyk70f09f8kfj3kh283vl09b1a2c477w";
  };

  cargoSha256 = "0k200p6wgwb60ax1r8mjn3aq08zxpkqbfqpi3b25zi3xf83my44d";

  # fixes: error: the option `Z` is only accepted on the nightly compiler
  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    alsa-lib
    lame
  ];

  meta = with lib; {
    description = "A Spotify downloader written in rust";
    homepage = "https://github.com/oSumAtrIX/DownOnSpot";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
