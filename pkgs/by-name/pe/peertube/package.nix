{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchYarnDeps,
  nixosTests,
  brotli,
  fixup-yarn-lock,
  jq,
  fd,
  nodejs_20,
  which,
  yarn,
}:
let
  bcryptHostPlatformAttrs = {
    x86_64-linux = {
      arch = "linux-x64";
      libc = "glibc";
      hash = "sha256-C5N6VgFtXPLLjZt0ZdRTX095njRIT+12ONuUaBBj7fQ=";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      libc = "glibc";
      hash = "sha256-TerDujO+IkSRnHYlSbAKSP9IS7AT7XnQJsZ8D8pCoGc=";
    };
    x86_64-darwin = {
      arch = "darwin-x64";
      libc = "unknown";
      hash = "sha256-gphOONWujbeCCr6dkmMRJP94Dhp1Jvp2yt+g7n1HTv0=";
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      libc = "unknown";
      hash = "sha256-JMnELVUxoU1C57Tzue3Sg6OfDFAjfCnzgDit0BWzmlo=";
    };
  };
  bcryptAttrs =
    bcryptHostPlatformAttrs."${stdenv.hostPlatform.system}"
      or (throw "Unsupported architecture: ${stdenv.hostPlatform.system}");
  bcryptVersion = "5.1.1";
  bcryptLib = fetchurl {
    url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcryptVersion}/bcrypt_lib-v${bcryptVersion}-napi-v3-${bcryptAttrs.arch}-${bcryptAttrs.libc}.tar.gz";
    inherit (bcryptAttrs) hash;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "peertube";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "Chocobozzz";
    repo = "PeerTube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WbZFOOvX6WzKB9tszxJl6z+V6cDBH6Y2SjoxF17WvUo=";
  };

  yarnOfflineCacheServer = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-T1stKz8+1ghQBJB8kujwcqmygMdoswjFBL/QWAHSis0=";
  };

  yarnOfflineCacheClient = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/client/yarn.lock";
    hash = "sha256-jeE6Xpi/A1Ldbbp12rkG19auud61AZna/vbVE2mpp/8=";
  };

  yarnOfflineCacheAppsCli = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/apps/peertube-cli/yarn.lock";
    hash = "sha256-lcWtZGE/6XGm8KXmzSowCHAb/vGwBoqkwk32Ru3mMYU=";
  };

  yarnOfflineCacheAppsRunner = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/apps/peertube-runner/yarn.lock";
    hash = "sha256-OX9em03iqaRCqFuo2QO/r+CBdk7hHk3WY1EBXlFr1cY=";
  };

  outputs = [
    "out"
    "cli"
    "runner"
  ];

  nativeBuildInputs = [
    brotli
    fixup-yarn-lock
    jq
    which
    yarn
    fd
  ];

  buildInputs = [ nodejs_20 ];

  buildPhase = ''
    # Build node modules
    export HOME=$PWD
    fixup-yarn-lock ~/yarn.lock
    fixup-yarn-lock ~/client/yarn.lock
    fixup-yarn-lock ~/apps/peertube-cli/yarn.lock
    fixup-yarn-lock ~/apps/peertube-runner/yarn.lock
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheServer
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/client
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheClient
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

    # Switch sass-embedded to sass
    find node_modules/vite/dist -name "*.js" -type f -exec grep -l "sass-embedded" {} \; | while read file; do
      echo "Patching $file"
      sed -i 's/"sass-embedded"/"sass"/g; s/'"'"'sass-embedded'"'"'/'"'"'sass'"'"'/g' "$file"
    done

    cd ~/apps/peertube-cli
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheAppsCli
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    cd ~/apps/peertube-runner
    yarn config --offline set yarn-offline-mirror $yarnOfflineCacheAppsRunner
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

    patchShebangs ~/{node_modules,client/node_modules,/apps/peertube-cli/node_modules,apps/peertube-runner/node_modules,scripts}

    # Fix bcrypt node module
    cd ~/node_modules/bcrypt
    if [ "${bcryptVersion}" != "$(cat package.json | jq -r .version)" ]; then
      echo "Mismatching version please update bcrypt in derivation"
      exit
    fi
    mkdir -p ./lib/binding && tar -C ./lib/binding -xf ${bcryptLib}

    # Return to home directory
    cd ~

    # Build PeerTube server
    npm run build:server

    # Build PeerTube client
    npm run build:client

    # Build PeerTube cli
    npm run build:peertube-cli
    patchShebangs ~/apps/peertube-cli/dist/peertube.js

    # Build PeerTube runner
    npm run build:peertube-runner
    patchShebangs ~/apps/peertube-runner/dist/peertube-runner.js

    # Clean up declaration files
    find ~/dist/ \
      ~/packages/core-utils/dist/ \
      ~/packages/ffmpeg/dist/ \
      ~/packages/models/dist/ \
      ~/packages/node-utils/dist/ \
      ~/packages/server-commands/dist/ \
      ~/packages/transcription/dist/ \
      ~/packages/typescript-utils/dist/ \
      \( -name '*.d.ts' -o -name '*.d.ts.map' \) -type f -delete
  '';

  installPhase = ''
    mkdir -p $out/dist
    mv ~/dist $out
    mv ~/node_modules $out/node_modules
    mkdir $out/client
    mv ~/client/{dist,node_modules,package.json,yarn.lock} $out/client
    mkdir -p $out/packages/{core-utils,ffmpeg,models,node-utils,server-commands,transcription,typescript-utils}
    mv ~/packages/core-utils/{dist,package.json} $out/packages/core-utils
    mv ~/packages/ffmpeg/{dist,package.json} $out/packages/ffmpeg
    mv ~/packages/models/{dist,package.json} $out/packages/models
    mv ~/packages/node-utils/{dist,package.json} $out/packages/node-utils
    mv ~/packages/server-commands/{dist,package.json} $out/packages/server-commands
    mv ~/packages/transcription/{dist,package.json} $out/packages/transcription
    mv ~/packages/typescript-utils/{dist,package.json} $out/packages/typescript-utils
    mv ~/{config,support,CREDITS.md,FAQ.md,LICENSE,README.md,package.json,yarn.lock} $out

    # Remove broken symlinks in node_modules from workspace packages that aren't needed
    # by the built artifact. If any new packages break the check for broken symlinks,
    # they should be checked before adding them here to make sure they aren't likely to
    # be needed, either now or in the future. If they might be, then we probably want
    # to move the package to $out above instead of removing the broken symlink.
    rm $out/node_modules/@peertube/{peertube-server,peertube-transcription-devtools,peertube-types-generator,tests}
    rm $out/client/node_modules/@peertube/{peertube-transcription-devtools,peertube-types-generator,tests,player}

    mkdir -p $cli/bin
    mv ~/apps/peertube-cli/{dist,node_modules,package.json,yarn.lock} $cli
    ln -s $cli/dist/peertube.js $cli/bin/peertube-cli

    mkdir -p $runner/bin
    mv ~/apps/peertube-runner/{dist,node_modules,package.json,yarn.lock} $runner
    ln -s $runner/dist/peertube-runner.js $runner/bin/peertube-runner

    # Create static gzip and brotli files
    fd -e css -e eot -e html -e js -e json -e svg -e webmanifest -e xlf \
      --type file --search-path $out/client/dist --threads $NIX_BUILD_CORES \
      --exec gzip -9 -n -c {} > {}.gz \;\
      --exec brotli --best -f {} -o {}.br
  '';

  passthru.tests.peertube = nixosTests.peertube;

  meta = {
    description = "Free software to take back control of your videos";
    longDescription = ''
      PeerTube aspires to be a decentralized and free/libre alternative to video
      broadcasting services.
      PeerTube is not meant to become a huge platform that would centralize
      videos from all around the world. Rather, it is a network of
      inter-connected small videos hosters.
      Anyone with a modicum of technical skills can host a PeerTube server, aka
      an instance. Each instance hosts its users and their videos. In this way,
      every instance is created, moderated and maintained independently by
      various administrators.
      You can still watch from your account videos hosted by other instances
      though if the administrator of your instance had previously connected it
      with other instances.
    '';
    license = lib.licenses.agpl3Plus;
    homepage = "https://joinpeertube.org/";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      # feasible, looking for maintainer to help out
      # "x86_64-darwin" "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      immae
      izorkin
      stevenroose
    ];
  };
})
