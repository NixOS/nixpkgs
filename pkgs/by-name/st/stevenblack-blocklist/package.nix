{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stevenblack-blocklist";
  version = "3.16.75";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    tag = finalAttrs.version;
    hash = "sha256-U1EDwPWYmG8F/EpNA0hOz//SC1o8spbTqRc/xl8hB5Y=";
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

  meta = {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      moni
      Guanran928
      frontear
    ];
  };
})
