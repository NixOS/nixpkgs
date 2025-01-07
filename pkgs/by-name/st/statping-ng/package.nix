{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  yarn,
  nodejs,
  go-rice,
  go,
  git,
  cacert,
  webpack-cli,
  jq,
}:

buildGoModule rec {
  pname = "statping-ng";
  version = "0.92.0";

  src = fetchFromGitHub {
    owner = "statping-ng";
    repo = "statping-ng";
    tag = "v${version}";
    hash = "sha256-E4sVIa8sKmjRcduATTHLklkr+LKX6KucDw42uVFhK4g=";
  };

  env = {
    CYPRESS_INSTALL_BINARY = 0;
  };

  offlineCache = stdenv.mkDerivation {
    name = "${pname}-${version}-yarn-offline-cache";
    inherit src env;

    nativeBuildInputs = [
      yarn
      nodejs
      cacert
      jq
      go
      git
    ];

    buildPhase = ''
      runHook preBuild
      export HOME="$(mktemp -d)"
      ls -la
      cd frontend
      mkdir yarnCache
      yarn config set enableTelemetry 0
      yarn config set cacheFolder yarnCache
      yarn --cache-folder yarnCache
      yarn config set --json supportedArchitectures.os '[ "linux", "darwin" ]'
      yarn config set --json supportedArchitectures.cpu '["arm64", "x64"]'
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out
      cp -r yarnCache/v6 $out
      cp -r node_modules $out
    '';

    doCheck = false;
    dontConfigure = true;
    dontFixup = true;

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash =
      {
        x86_64-linux = "sha256-7NsGcogpLE9sTbaG3M0I72dp4z1r5MaJ6tzCbHHDnac=";
        aarch64-linux = "sha256-HJWsWhkF+Eq24vZHcLWFCj/qxpx5Jc+dstlE1MCr4Iw=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  disallowedRequisites = [ offlineCache ];
  proxyVendor = true;
  vendorHash = "sha256-ZcNOI5/Fs7/U8/re89YpJ3qlMaQStLrrNHXiHuBQwQk=";

  nativeBuildInputs = [
    go-rice
    go
    git
    yarn
    nodejs
    webpack-cli
  ];

  subPackages = [
    "cmd/"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  tags = [
    "netgo"
    "ousergo"
  ];

  postConfigure = ''
    # Help node-gyp find Node.js headers
    # (see https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#pitfalls-javascript-yarn2nix-pitfalls)
    export HOME="$(mktemp -d)"
    cp -r ${offlineCache}/node_modules frontend/
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}
    cd frontend
    yarn config set enableTelemetry 0
    yarn config set cacheFolder $offlineCache
    yarn install --immutable-cache --offline --cacheFolder $offlineCache
    export NODE_OPTIONS=--max_old_space_size=4096
    NODE_OPTIONS=--openssl-legacy-provider NODE_ENV=production webpack --mode production
    cd ..
    cp -r frontend/dist source
    cp -r frontend/src/assets/scss source/dist
    cp -r frontend/public/robots.txt source/dist
    cd source && rice embed-go && cd -
  '';

  postInstall = ''
    mkdir -p $out/bin
    mv $out/bin/cmd $out/bin/statping-ng
    $out/bin/statping-ng version | grep ${version} > /dev/null
  '';

  doCheck = false;

  meta = {
    description = "Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins";
    homepage = "https://github.com/statping-ng/statping-ng";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      FKouhai
    ];
    platforms = lib.platforms.linux;
    mainProgram = "statping-ng";
  };
}
