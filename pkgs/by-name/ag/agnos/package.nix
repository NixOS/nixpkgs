{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "agnos";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "krtab";
    repo = "agnos";
    tag = "v${version}";
    hash = "sha256-wHzKHduxqG7PBsGK39lCRyzhf47mdjCXhn3W1pOXQO0=";
  };

  cargoHash = "sha256-iRHJ8xmF9CzuVDkBVHD1LGv/YQS5V+oV05+7Pe04ckM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

<<<<<<< HEAD
  meta = {
    description = "Obtains certificates from Let's Encrypt using DNS-01 without the need for API access to the DNS provider";
    homepage = "https://github.com/krtab/agnos";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justinas ];
=======
  meta = with lib; {
    description = "Obtains certificates from Let's Encrypt using DNS-01 without the need for API access to the DNS provider";
    homepage = "https://github.com/krtab/agnos";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.tests = nixosTests.agnos;
}
