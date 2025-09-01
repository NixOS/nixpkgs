{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.31";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AxaJK39QkhTTATKh+lYzS3zxAlIElJUyOaUCi2pjXhQ=";
  };

  cargoHash = "sha256-sXqUbG6GlesC6NtM+xwzopuyswIezr8CLzidCx6fMQk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "star-history";
  };
}
