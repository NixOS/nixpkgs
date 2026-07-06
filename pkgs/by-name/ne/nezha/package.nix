{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-swag,
  versionCheckHook,
  dbip-country-lite,
  formats,
  nix-update-script,
  nixosTests,
  nezha-theme-admin,
  nezha-theme-user,
  withThemes ? [ ],
}:

let
  frontendName = lib.removePrefix "nezha-theme-";

  frontend-templates =
    let
      mkTemplate =
        theme: extra:
        {
          path = "${frontendName theme.pname}-dist";
          name = frontendName theme.pname;
          repository = theme.meta.homepage or "";
          author = theme.src.owner or "";
          version = theme.version;
          is_official = false;
          is_admin = false;
        }
        // extra;

      officialThemes = [
        (mkTemplate nezha-theme-admin {
          name = "OfficialAdmin";
          is_admin = true;
          is_official = true;
        })
        (mkTemplate nezha-theme-user {
          name = "Official";
          is_official = true;
        })
      ];

      communityThemes = map (t: mkTemplate t { }) withThemes;
    in
    (formats.yaml { }).generate "frontend-templates.yaml" (officialThemes ++ communityThemes);
in
buildGoModule (finalAttrs: {
  pname = "nezha";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "nezha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HsDymQ1y4ouUMpcpSycSfbwJm+hzct7U0Wjm/ouorO0=";
  };

  proxyVendor = true;

  prePatch =
    let
      allThemes = [
        nezha-theme-admin
        nezha-theme-user
      ]
      ++ withThemes;

      installThemeCmd = theme: "cp -r ${theme} cmd/dashboard/${frontendName theme.pname}-dist";
    in
    ''
      rm -rf cmd/dashboard/*-dist

      cp ${frontend-templates} service/singleton/frontend-templates.yaml
      ${lib.concatMapStringsSep "\n" installThemeCmd allThemes}
    '';

  patches = [
    # Nezha originally used ipinfo.mmdb to provide geoip query feature.
    # Unfortunately, ipinfo.mmdb must be downloaded with token.
    # Therefore, we patch the nezha to use dbip-country-lite.mmdb in nixpkgs.
    ./dbip.patch
  ];

  postPatch = ''
    cp ${dbip-country-lite.mmdb} pkg/geoip/geoip.db
  '';

  nativeBuildInputs = [ go-swag ];

  # Generate code for Swagger documentation endpoints (see cmd/dashboard/docs).
  postConfigure = ''
    GOROOT=''${GOROOT-$(go env GOROOT)} swag init --pd -d cmd/dashboard -g main.go -o cmd/dashboard/docs
  '';

  vendorHash = "sha256-rYzkaJqk5r31Uagn1FRFDeICUeK392o1fyP6IBk9zgk=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/nezha/service/singleton.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true; # TestOptionalAuth_PATWithoutScopeIsDenied
  checkFlags = "-skip=^TestSplitDomainSOA$";

  postInstall = ''
    mv $out/bin/dashboard $out/bin/nezha
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) nezha;
    };
  };

  meta = {
    description = "Self-hosted, lightweight server and website monitoring and O&M tool";
    homepage = "https://github.com/nezhahq/nezha";
    changelog = "https://github.com/nezhahq/nezha/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha";
  };
})
