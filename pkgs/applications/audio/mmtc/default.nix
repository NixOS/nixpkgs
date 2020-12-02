{ callPackage, fetchFromGitHub, rustPlatform, stdenv }:

let
  rust = (let
    mozilla = fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      rev = "8c007b60731c07dd7a052cce508de3bb1ae849b4";
      sha256 = "1zybp62zz0h077zm2zmqs2wcg3whg6jqaah9hcl1gv4x8af4zhs6";
    };
  in callPackage "${mozilla.out}/package-set.nix"
  { }).latest.rustChannels.nightly.rust;
in rustPlatform.buildRustPackage.override {
  cargo = rust;
  rustc = rust;
} rec {
  pname = "mmtc";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "136ixb6d2dnz5rl9grxb49nq1qkilczbfyfbgi0xzkkzz2119dlm";
  };

  RUSTFLAGS = "";

  cargoSha256 = "1g3512gi4z3hykr9f04rslm6aymk8lph6g851qwq0aip8jjqgz5h";

  meta = with stdenv.lib; {
    description =
      "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    changelog = "https://github.com/figsoda/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.all;
  };
}
