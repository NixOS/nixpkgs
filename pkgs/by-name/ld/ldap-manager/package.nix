{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nodejs,
  pnpm_9,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ldap-manager";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "netresearch";
    repo = "ldap-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CmvNBN3n6foeweA+Wgr8IiQbRvT8kZxN7tEmxBYysJw=";
  };

  vendorHash = "sha256-4FcDz1hS3N2CvVbPa7g+k8qDEcoWsPHxYeolMMs7TPA=";

  nativeBuildInputs = [
    (buildGoModule {
      pname = "templ";
      version = "0.3.833";

      src = fetchFromGitHub {
        owner = "a-h";
        repo = "templ";
        tag = "v0.3.833";
        hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
      };

      vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";

      subPackages = [ "cmd/templ" ];
    })
  ];

  preBuild =
    let
      frontend = stdenvNoCC.mkDerivation {
        pname = "${finalAttrs.pname}-frontend";
        inherit (finalAttrs) version src;

        nativeBuildInputs = [
          nodejs
          pnpm_9.configHook
        ];

        pnpmDeps = pnpm_9.fetchDeps {
          inherit (finalAttrs) pname version src;
          fetcherVersion = 1;
          hash = "sha256-jyb7O/AIbH5L4i/vexpTCehgFixallOTl2WlHWCEAMM=";
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
    ''
      cp -r ${frontend}/static/* internal/web/static/
      templ generate
    '';

  ldflags = [
    "-s"
    "-X github.com/netresearch/ldap-manager/internal.Version=${finalAttrs.version}"
    "-X github.com/netresearch/ldap-manager/internal.BuildTimestamp=1970-01-01T00:00:00"
  ];

  postInstall = ''
    mv $out/bin/ldap-manager $out/bin/ldap-passwd
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = false;

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
