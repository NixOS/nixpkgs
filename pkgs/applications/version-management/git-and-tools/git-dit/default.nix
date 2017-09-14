{ stdenv
, fetchFromGitHub
, rustPlatform
}:

with rustPlatform;

buildRustPackage rec {
  name = "git-dit-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "neithernut";
    repo = "git-dit";
    rev = "v${version}";
    sha256 = "1xl698ngl0b7hd21917zavxcyba267xcsmri2q5a8mgavyssjazp";
  };

  depsSha256 = "19lrj4i6vzmf22r6xg99zcwvzjpiar8pqin1m2nvv78xzxx5yvgb";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Decentralized Issue Tracking for git";
    license = licenses.gpl2;
    maintainers = with maintainers; [ profpatsch matthiasbeyer ];
  };


}
