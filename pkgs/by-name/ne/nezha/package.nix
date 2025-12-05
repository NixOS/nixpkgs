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
  pname = "nezha";
  version = "1.14.9";

  frontendName = lib.removePrefix "nezha-theme-";

  frontend-templates =
    let
      mkTemplate = theme: {
        path = "${frontendName theme.pname}-dist";
        name = frontendName theme.pname;
        repository = theme.meta.homepage;
        author = theme.src.owner;
        version = theme.version;
        isofficial = false;
        isadmin = false;
      };
    in
    (formats.yaml { }).generate "frontend-templates.yaml" (
      [
        (
          mkTemplate nezha-theme-admin
          // {
            name = "OfficialAdmin";
            isadmin = true;
            isofficial = true;
          }
        )
        (
          mkTemplate nezha-theme-user
          // {
            name = "Official";
            isofficial = true;
          }
        )
      ]
      ++ map mkTemplate withThemes
    );
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "nezha";
    tag = "v${version}";
    hash = "sha256-q4LxqoelZ0Haz8rArINOPvopQQKGnkqIMZ2INo/2C3c=";
  };

  proxyVendor = true;

  prePatch = ''
    rm -rf cmd/dashboard/*-dist

    cp ${frontend-templates} service/singleton/frontend-templates.yaml
  ''
  + lib.concatStringsSep "\n" (
    map (theme: "cp -r ${theme} cmd/dashboard/${frontendName theme.pname}-dist") (
      [
        nezha-theme-admin
        nezha-theme-user
      ]
      ++ withThemes
    )
  );

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

  vendorHash = "sha256-Q+ur9hIG0xVJHdi79K5e4sV8xuR45qp195ptEDbHAvc=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/nezha/service/singleton.Version=${version}"
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
    changelog = "https://github.com/nezhahq/nezha/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha";
  };
}
