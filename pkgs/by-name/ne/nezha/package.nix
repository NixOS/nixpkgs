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
<<<<<<< HEAD
=======
  pname = "nezha";
  version = "1.14.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  frontendName = lib.removePrefix "nezha-theme-";

  frontend-templates =
    let
<<<<<<< HEAD
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
  version = "1.14.10";
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "nezha";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-tgjLkNSNEQCJP1/Pcgfldl5DGQnzca6KMrqEjl45ex4=";
=======
    tag = "v${version}";
    hash = "sha256-q4LxqoelZ0Haz8rArINOPvopQQKGnkqIMZ2INo/2C3c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  proxyVendor = true;

<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    "-X github.com/nezhahq/nezha/service/singleton.Version=${finalAttrs.version}"
=======
    "-X github.com/nezhahq/nezha/service/singleton.Version=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/nezhahq/nezha/releases/tag/v${finalAttrs.version}";
=======
    changelog = "https://github.com/nezhahq/nezha/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
