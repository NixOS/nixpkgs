{
  lib,
  buildNpmPackage,
  dnsutils,
  fetchFromGitHub,
  fetchNpmDeps,
  iputils,
  makeWrapper,
  nodejs_26,
  playwright-driver,
  playwright-test,
  traceroute,
}:

let
  version = "12.0.33";

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  # Probe depends on Common as `file:../Common`, so npm symlinks it rather than installing it.
  commonNpmDeps = fetchNpmDeps {
    name = "oneuptime-common-npm-deps-${version}";
    src = "${src}/Common";
    hash = "sha256-rDw1lEtDiqJogkSCZKYaRJQwNqCnGSC6za0pV18RN+c=";
  };
in
buildNpmPackage {
  pname = "oneuptime-probe";
  inherit version src;

  __structuredAttrs = true;

  sourceRoot = "${src.name}/Probe";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-G3AAe4J4Yh/Fz6pHOgxpcWBbpPnnIeiKQHYd2Iyz3oM=";

  # The one optional dependency is msnodesqlv8, a native driver needing unixODBC.
  npmFlags = [ "--omit=optional" ];

  nativeBuildInputs = [ makeWrapper ];

  # Common still needs the optional dependencies Probe omits
  preBuild = ''
    chmod -R u+w ../Common

    (
      export npmRoot=../Common
      export npmDeps=${commonNpmDeps}
      npmFlags=""
      npmFlagsArray=()

      npmConfigHook
    )
  '';

  dontNpmBuild = true;

  # NPM's playwright fetches browsers from a postinstall the sandbox blocks. Replace it with nixpkgs's own
  postBuild = ''
    for pkg in playwright playwright-core; do
      rm -rf node_modules/$pkg
      cp -r --no-preserve=mode ${playwright-test}/lib/node_modules/$pkg node_modules/$pkg
    done
  '';

  installPhase =
    let
      probeDir = "$out/lib/oneuptime/Probe";
    in
    ''
      runHook preInstall

      install -d $out/lib/oneuptime
      cp -a ../Common $out/lib/oneuptime/Common
      cp -a . ${probeDir}

      makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-probe \
        --chdir ${probeDir} \
        --add-flags "--no-node-snapshot" \
        --add-flags "--require ts-node/register" \
        --add-flags ${probeDir}/Index.ts \
        --set TS_NODE_TRANSPILE_ONLY 1 \
        --set APP_VERSION ${version} \
        --set PLAYWRIGHT_BROWSERS_PATH ${
          # Synthetic monitoring doesn't use webkit and disabling reclaims 1GB
          playwright-driver.browsers.override { withWebkit = false; }
        } \
        --prefix PATH : ${
          # Monitors shell out to these for networking checks
          lib.makeBinPath [
            dnsutils
            iputils
            traceroute
          ]
        }

      runHook postInstall
    '';

  meta = {
    description = "OneUptime monitoring probe";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-probe";
    platforms = lib.platforms.linux;
  };
}
