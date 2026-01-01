{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stevenblack-blocklist";
<<<<<<< HEAD
  version = "3.16.44";
=======
  version = "3.16.36";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-NetBsY30rvt82ueoUSgl7VWhdOPmEy7BjSgZS794MJg=";
=======
    hash = "sha256-7sOoxpT65O3Mks9+xfISuRgx55E6eRdbsDpdMafTq98=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    # default src fallback
    "out"

    # base hosts file
    "ads"

    # extensions only
    "fakenews"
    "gambling"
    "porn"
    "social"
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out $ads $fakenews $gambling $porn $social

    # out
    find alternates -type f -not -name "hosts" -exec rm {} +
    cp -r alternates $out
    install -Dm644 hosts $out

    # ads
    install -Dm644 hosts $ads

    # extensions
    install -Dm644 alternates/fakenews-only/hosts $fakenews
    install -Dm644 alternates/gambling-only/hosts $gambling
    install -Dm644 alternates/porn-only/hosts $porn
    install -Dm644 alternates/social-only/hosts $social

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      moni
      Guanran928
      frontear
    ];
  };
})
