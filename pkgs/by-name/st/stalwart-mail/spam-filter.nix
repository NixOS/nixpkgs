{
  lib,
  fetchFromGitHub,
  stdenv,
  stalwart-mail,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spam-filter";
<<<<<<< HEAD
  version = "2.0.5";
=======
  version = "2.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "spam-filter";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-2D/0mnkV4G/Gyr48rbMGTo6uTL7pe+AT+DNKqkBTIbA=";
=======
    hash = "sha256-unSRgmXE5T1QfE41E29BjJKpEAnMtYiAefcL2p7Cjak=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildPhase = ''
    bash ./build.sh
  '';

  installPhase = ''
    mkdir -p $out
    cp spam-filter.toml $out/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Secure & modern all-in-one mail server Stalwart (spam-filter module)";
    homepage = "https://github.com/stalwartlabs/spam-filter";
    changelog = "https://github.com/stalwartlabs/spam-filter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    inherit (stalwart-mail.meta) maintainers;
  };
})
