{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "stevenblack-blocklist";
  version = "3.14.82";

  src = fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "refs/tags/${finalAttrs.version}";
    hash ="sha256-FS9+w+9QPBd6hCtX7C5x/xm4nGCA0lOtYgjefkQNbbg=";
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

    mkdir -p $out

    cp -R $src $out

    install -Dm644 $src/hosts $ads

    install -Dm644 $src/alternates/fakenews-only/hosts $fakenews
    install -Dm644 $src/alternates/gambling-only/hosts $gambling
    install -Dm644 $src/alternates/porn-only/hosts $porn
    install -Dm644 $src/alternates/social-only/hosts $social

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [
      moni
      Guanran928
      frontear
    ];
  };
})
