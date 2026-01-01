{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprisence";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.2.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-edjpaYXrY3DCwY8jqXAeqR5GJgWirx9w4lNGMgYHvJU=";
  };

  cargoHash = "sha256-AqEYb20W2atVwnAAMtXSLP4x/KwRfcWidNTAINXUpjw=";
=======
    hash = "sha256-prRnDQvBewgeaHZGonwnRHoVgbSgo9FINsUu4LoI078=";
  };

  cargoHash = "sha256-yL6b6X7OHuiILDowTsWdvTvftO2p6KmfmFQ1UxHjsAg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
  ];

<<<<<<< HEAD
  meta = {
    description = "Highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toasteruwu ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
=======
  meta = with lib; {
    description = "Highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    license = licenses.mit;
    maintainers = with maintainers; [ toasteruwu ];
    sourceProvenance = with sourceTypes; [ fromSource ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mprisence";
  };
})
