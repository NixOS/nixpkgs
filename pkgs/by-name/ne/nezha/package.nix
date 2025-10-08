{
  lib,
  buildGo124Module,
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
  version = "1.14.3";

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
buildGo124Module {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "nezha";
    tag = "v${version}";
    hash = "sha256-ORPu7mCNqHfuXq/nB3TuNoevbw5ZMvZFetR6NPX/b3U=";
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

  vendorHash = "sha256-e4FlXKE9A7WpZpafSv0Ais97cyta56ElD9pL4eIvnUk=";

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
