{ pkgs
, lib
, callPackage
, fetchFromGitHub
, makeRustPlatform
, openssl
, pkg-config
}:

let

  pname = "git-repo-manager";
  version = "0.7.12";

  src = fetchFromGitHub {
    owner = "hakoerber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FFzarNPI3GYjt98cAcypxDN53Nl372b7KYA4tUCbD7Y=";
  };

  rustPlatform =
    let
      mozillaOverlay = fetchFromGitHub {
        owner = "mozilla";
        repo = "nixpkgs-mozilla";
        rev = "78e723925daf5c9e8d0a1837ec27059e61649cb6";
        sha256 = "sha256-A1gO8zlWLv3+tZ3cGVB1WYvvoN9pbFyv0xIJHcTsckw=";
      };
      mozilla = import "${mozillaOverlay.out}/package-set.nix" { inherit pkgs; };

      # TODO: use the rust-toolchain file once next grm version is tagged
      # (rust-toolchain file has been added to master since the last release version)
      rust = (mozilla.rustChannelOf {
        channel = "nightly";
        date = "2023-02-25";
        sha256 = "sha256-uLFgqCLudpypnhz3+kMivOgJzaFa74xvUEpphyTYibw=";
      }).rust;
    in
    makeRustPlatform {
      cargo = rust;
      rustc = rust;
    };

in

rustPlatform.buildRustPackage rec {

  inherit
    pname
    version
    src
    ;

  cargoSha256 = "sha256-lDEzB4x++TqhjKbeMfPscl+tGmxfDYp8mLGHkZPvras=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A git tool to manage worktrees and integrate with GitHub and GitLab";
    homepage = "https://github.com/hakoerber/${pname}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
