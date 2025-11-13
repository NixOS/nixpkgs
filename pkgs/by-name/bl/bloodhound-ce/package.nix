{
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  nodejs_22,
  p7zip,
  python311,
  runCommand,
  stdenv,
  yarn-berry_3,
}:
let
  inherit (lib) concatLines flip pipe;
  inherit (lib.versions) major minor patch;

  # reference: https://github.com/SpecterOps/BloodHound/blob/v8.3.1/dockerfiles/bloodhound.Dockerfile

  pname = "bloodhound-ce";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "SpecterOps";
    repo = "BloodHound";
    tag = "v${version}";
    hash = "sha256-mIoQkxUxv2BktFGSLKo5RVEF/7JByiyCWC2o9GWS9w4=";
  };

  filter = flip pipe [
    (map (x: ''
      mkdir -p "$out/${dirOf x}"
      cp -r "${src}/${x}" "$out/${x}"
    ''))
    concatLines
    (runCommand "filtered-source" { })
  ];

  yarn-berry = yarn-berry_3;

  ##############################################################################

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "bloodhound-ce-frontend";
    inherit version;

    src = filter [
      ".yarn/plugins"
      ".yarn/releases"
      ".yarnrc.yml"
      "cmd/ui"
      "constraints.pro"
      "package.json"
      "packages/javascript"
      "yarn-workspaces.json"
      "yarn.lock"
    ];

    patches = [
      # cmd/ui/package.json includes "git@github.com:BloodHoundAD/dagre.git"
      # which is fetched using SSH, and that doesn't work in the Nix sandbox
      # so we just replace it with a standard HTTPS URL
      ./fetch-dagrejs-via-https.patch
    ];

    nativeBuildInputs = [
      nodejs_22
      yarn-berry
      yarn-berry.yarnBerryConfigHook
      python311 # for node-gyp builds
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit (finalAttrs) src patches missingHashes;
      hash = "sha256-0OXOZ9QVpOxqE4r1Gj0dOlEijY+JAqOvanntp5D5t1M=";
    };

    env.JOBS = "max";

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

  ##############################################################################

  collectors =
    let
      azver = "v2.8.1";
      shver = "v2.8.0";

      sharphound = fetchurl {
        url = "https://github.com/SpecterOps/SharpHound/releases/download/${shver}/sharphound_${shver}_windows_x86.zip";
        hash = "sha256-BjBOxjhQYpqD/qUy9EsuXplK8JAuPU/LE2O0Ooxr+r4=";
      };
    in
    pipe
      [
        {
          os = "darwin";
          arch = "amd64";
          hash = "sha256-HD5vMc6vt71wj5ST6On417iY3DJZQXdG8Il73H22m9Q=";
        }
        {
          os = "darwin";
          arch = "arm64";
          hash = "sha256-57i+/9gV17pqQqqnEianJdJ6Jtg4DsExMkfAEqaeNns=";
        }
        {
          os = "linux";
          arch = "amd64";
          hash = "sha256-8wrEef0+ik5WAsIV7tInyUlNnsUBw6Ux9LE7gVS3Fhs=";
        }
        {
          os = "linux";
          arch = "arm64";
          hash = "sha256-23lokcbd2Yp9pWibsb5SNW/YE/eHpHCFZv2PbBlw0Xo=";
        }
        {
          os = "windows";
          arch = "amd64";
          hash = "sha256-IkEfEh2VFNTnuUAez6/vMY7sMv4rtDR3Paerev/xoqs=";
        }
        {
          os = "windows";
          arch = "arm64";
          hash = "sha256-qEgmO7oNy/pUXH7lbOoJxNznl2mPofj2R5RGBZdOoUI=";
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
  inherit pname version;

  src = filter [
    "cmd/api"
    "go.mod"
    "go.sum"
    "packages/go"
  ];

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

  passthru = {
    inherit frontend collectors;
  };

  meta = with lib; {
    description = "Six Degrees of Domain Admin";
    homepage = "https://github.com/SpecterOps/BloodHound";
    changelog = "https://github.com/SpecterOps/BloodHound/releases/tag/v${version}";
    downloadPage = "https://github.com/SpecterOps/BloodHound/releases";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eleonora ];
    mainProgram = "bloodhound-ce";
  };
}
