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

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-probe";
  version = "14.0.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-AcbAL+jsYsEoSIcIcWU2xypWt232Fi/5+bVt0Unnojk=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/Probe";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-HbMI7ZfS+5I16nTEWUZQ1evRRlinI41/5RNpwdkvpP8=";

  # The one optional dependency is msnodesqlv8, a native driver needing unixODBC.
  npmFlags = [ "--omit=optional" ];

  nativeBuildInputs = [ makeWrapper ];

  # unpackPhase only makes sourceRoot writable, and Common sits outside it.
  postPatch = ''
    chmod -R u+w ..
  '';

  # Probe depends on Common as `file:../Common`, so npm symlinks it rather than
  # installing it. Common still needs the optional dependencies Probe omits.
  preBuild = ''
    (
      cd ../Common
      export npmDeps=${
        fetchNpmDeps {
          name = "oneuptime-common-npm-deps-${finalAttrs.version}";
          src = "${finalAttrs.src}/packages/Common";
          hash = "sha256-APolLZbF0BWeN/bkSMelVOjc4TUEBlwcPcniq5+Ba1Y=";
        }
      }
      npmFlags=()
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

  installPhase = ''
    runHook preInstall

    install -d $out/lib/oneuptime
    cp -a ../Common $out/lib/oneuptime/Common
    cp -a . $out/lib/oneuptime/Probe

    makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-probe \
      --chdir $out/lib/oneuptime/Probe \
      --add-flags "--no-node-snapshot --require ts-node/register $out/lib/oneuptime/Probe/Index.ts" \
      --set TS_NODE_TRANSPILE_ONLY 1 \
      --set APP_VERSION ${finalAttrs.version} \
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
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-probe";
    platforms = lib.platforms.linux;
  };
})
