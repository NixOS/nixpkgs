{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-swag,
  versionCheckHook,
  dbip-country-lite,
  formats,
  nix-update-script,
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
  version = "1.14.14";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "nezha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F6M/bpuupQDDxKrafWlB3vk6iKf1QfJU1x0p3MAzzhM=";
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
  preBuild = ''
    GOROOT=''${GOROOT-$(go env GOROOT)} swag init --pd -d . -g ./cmd/dashboard/main.go -o ./cmd/dashboard/docs --parseGoList=false
  '';

  vendorHash = "sha256-9vJzQqXkoENRapcHp/afSCcdOrt8bxrIyJT/cBeas+A=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/nezha/service/singleton.Version=${finalAttrs.version}"
  ];

  checkFlags = "-skip=^TestSplitDomainSOA$";

  postInstall = ''
    mv $out/bin/dashboard $out/bin/nezha
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
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
