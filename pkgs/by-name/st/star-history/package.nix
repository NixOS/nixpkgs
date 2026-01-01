{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
<<<<<<< HEAD
  version = "1.0.32";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JilIVnxSXEK525TK+mHal+37G7PYcaQogVC2ozYeLY4=";
  };

  cargoHash = "sha256-9qKdn3q4d4N36+jng4ZKfazcxR9iMOh1PeUNYfZz8pg=";
=======
  version = "1.0.31";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AxaJK39QkhTTATKh+lYzS3zxAlIElJUyOaUCi2pjXhQ=";
  };

  cargoHash = "sha256-sXqUbG6GlesC6NtM+xwzopuyswIezr8CLzidCx6fMQk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

<<<<<<< HEAD
  meta = {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.matthiasbeyer ];
=======
  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "star-history";
  };
}
