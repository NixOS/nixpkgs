{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  stdenvNoCC,
  nodejs,
  pnpm_10,
  templ,
  pnpmConfigHook,
  fetchPnpmDeps,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "netresearch";
    repo = "ldap-manager";
    tag = "v${version}";
    hash = "sha256-G4UUgjTbRmVmbLvSv95kwhqnTUCygW8plkdYFGcHBqE=";
  };

  frontend = stdenvNoCC.mkDerivation {
    pname = "ldap-manager-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "ldap-manager";
      inherit version src;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-XFdKb43NxslB60GEDIBbKFYRClq0SeUqPwA81SAZaug=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm css:build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r internal/web/static $out/static

      runHook postInstall
    '';
  };
in

buildGoModule (finalAttrs: {
  pname = "ldap-manager";
  inherit version src;

  vendorHash = "sha256-ekgnjhO9GAml/A8pf9Hj6lseYJkvvf87f7tiwWixyKU=";

  nativeBuildInputs = [
    templ
  ];

  patches = [
    # Add --version support
    # https://github.com/netresearch/ldap-manager/pull/462
    (fetchpatch {
      url = "https://github.com/netresearch/ldap-manager/pull/462.patch";
      hash = "sha256-OykLep7uGZ79/lqOC4KNnSThCqQsmDo6vDqaoWVX3XI=";
    })
  ];

  excludedPackages = [
    "internal/e2e"
    "internal/integration"
  ];

  preBuild = ''
    cp -r ${frontend}/static/* internal/web/static/
    templ generate
  '';

  ldflags = [
    "-s"
    "-X github.com/netresearch/ldap-manager/internal/version.Version=${finalAttrs.version}"
    "-X github.com/netresearch/ldap-manager/internal/version.BuildTimestamp=1970-01-01T00:00:00"
  ];

  postInstall = ''
    mv $out/bin/ldap-manager $out/bin/ldap-passwd
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web frontend that allows users to administrate their LDAP users";
    homepage = "https://github.com/netresearch/ldap-manager";
    changelog = "https://github.com/netresearch/ldap-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "ldap-passwd";
  };
})
