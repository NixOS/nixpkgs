{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "nrdxp";
    repo = "cfdyndns";
    rev = "v${version}";
    hash = "sha256-OV1YRcZDzYy1FP1Bqp9m+Jxgu6Vc0aWpbAffNcdIW/4=";
  };

  cargoHash = "sha256-VA4oT8WeXdxjr/tKbrRuZPLpXmmXbeKC5d6laRHr+uo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "CloudFlare Dynamic DNS Client";
    mainProgram = "cfdyndns";
    homepage = "https://github.com/nrdxp/cfdyndns";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      colemickens
    ];
    platforms = with lib.platforms; linux;
=======
    maintainers = with maintainers; [
      colemickens
    ];
    platforms = with platforms; linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
