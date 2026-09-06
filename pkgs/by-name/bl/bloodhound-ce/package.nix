{
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  nodejs_22,
  p7zip,
  python3,
  stdenv,
  versionCheckHook,
  yarn-berry_3,
}:
let
  inherit (lib) concatLines pipe;
  inherit (lib.versions) major minor patch;

  # reference: https://github.com/SpecterOps/BloodHound/blob/main/dockerfiles/bloodhound.Dockerfile

  pname = "bloodhound-ce";
  version = "8.4.1";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "BloodHound";
    tag = "v${version}";
    hash = "sha256-TEmt12ELVIj0RgKkw0VRYaLX5okOv3EvLLB1cWJmXFw=";
  };

  yarn-berry = yarn-berry_3;

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "bloodhound-ce-frontend";
    inherit version src;

    patches = [
      # cmd/ui/package.json includes "git@github.com:BloodHoundAD/dagre.git"
      # which requires a valid SSH credential to fetch
      ./fetch-dagrejs-via-https.patch
    ];

    nativeBuildInputs = [
      nodejs_22
      yarn-berry
      yarn-berry.yarnBerryConfigHook

      # for node-gyp builds
      (python3.withPackages (
        p: with p; [
          distutils
        ]
      ))
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit (finalAttrs) src patches missingHashes;
      hash = "sha256-NNu0YwtjTmEpJu3ps/hVgQ2L9iHIxR9afkZ5s2Wv/bk=";
    };

    preConfigure = ''
      export JOBS=$NIX_BUILD_CORES
    '';

    buildPhase = ''
      runHook preBuild
      yarn build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r cmd/ui/dist $out
      runHook postInstall
    '';
  });

  collectors =
    let
      azver = "v2.8.2";
      shver = "v2.8.1";

      sharphound = fetchurl {
        url = "https://github.com/SpecterOps/SharpHound/releases/download/${shver}/sharphound_${shver}_windows_x86.zip";
        hash = "sha256-UepCKQ8TV2CCeNvoU5pu5twH22oRSpbo/Hn4aJtXjao=";
      };
    in
    pipe
      [
        {
          os = "darwin";
          arch = "amd64";
          hash = "sha256-Y5s3OW/kHNHQ/44r9N5TZQOcNatBK6b9TDNoP3aiqMA=";
        }
        {
          os = "darwin";
          arch = "arm64";
          hash = "sha256-hK8sTg3kBmayTqPbWk3m2Dj7ABDX6h21+LvKe0xzPCs=";
        }
        {
          os = "linux";
          arch = "amd64";
          hash = "sha256-MFECKv/bMC5Wwo//crIlyl6YDBZ+V0HD9MuhuWBpmAQ=";
        }
        {
          os = "linux";
          arch = "arm64";
          hash = "sha256-GG5hl0YXMgaP0BCjsTFY70Jlmu2Cx8Y1wWXAAUabffQ=";
        }
        {
          os = "windows";
          arch = "amd64";
          hash = "sha256-9235b2K+b0vXusGS7LcUiEaMW5EyHFrtYvNNxsTCIVg=";
        }
        {
          os = "windows";
          arch = "arm64";
          hash = "sha256-rXv50p8oYnYW9tCyzfCQ16UJrIFgd2ZMHJrpI2z+kus=";
        }
      ]
      [
        (map (
          x:
          "cp ${
            fetchurl {
              url = "https://github.com/SpecterOps/AzureHound/releases/download/${azver}/azurehound_${azver}_${x.os}_${x.arch}.zip";
              inherit (x) hash;
            }
          } azurehound_${azver}_${x.os}_${x.arch}.zip"
        ))
        concatLines
        (
          copyAzurehoundZips:
          stdenv.mkDerivation {
            pname = "bloodhound-ce-collectors";
            inherit version src;

            nativeBuildInputs = [ p7zip ];

            installPhase = ''
              mkdir -p $out/{azurehound,sharphound}

              ${copyAzurehoundZips}
              7z x 'azurehound_*.zip' '-oartifacts/*'
              (cd artifacts; 7z a -tzip -mx9 $out/azurehound/azurehound-${azver}.zip *)

              cp ${sharphound} $out/sharphound/sharphound-${shver}.zip
              for i in $out/*/*.zip; do sha256sum "$i" > "$i.sha256"; done
            '';
          }
        )
      ];
in
buildGoModule {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.majorVersion=${major version}"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.minorVersion=${minor version}"
    "-X github.com/specterops/bloodhound/cmd/api/src/version.patchVersion=${patch version}"
  ];

  subPackages = [
    "cmd/api/src/cmd/bhapi"
  ];

  vendorHash = "sha256-Lm6g0pxGVIuns6mUwnkbnBQQQp1V0TvEakX5fAo8qMo=";

  preBuild = ''
    rm -rf            cmd/api/src/api/static/assets
    cp -r ${frontend} cmd/api/src/api/static/assets
  '';

  postInstall = ''
    mv $out/bin/{bhapi,bloodhound-ce}

    wrapProgram $out/bin/bloodhound-ce \
      --set BHE_COLLECTORS_BASE_PATH ${collectors}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    inherit frontend collectors;
  };

  meta = {
    description = "Six Degrees of Domain Admin";
    homepage = "https://github.com/SpecterOps/BloodHound";
    changelog = "https://github.com/SpecterOps/BloodHound/releases/tag/v${version}";
    downloadPage = "https://github.com/SpecterOps/BloodHound/releases";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eleonora ];
    mainProgram = "bloodhound-ce";
  };
}
