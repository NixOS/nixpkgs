{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  python3,
  yarn,
  nodejs,
  removeReferencesTo,
  go-rice,
  nixosTests,
  testers,
  go,
  git,
  statping-ng,
  cacert,
  webpack-cli,
  moreutils,
  jq,
  faketty,
  xcbuild,
  tzdata,
}:
buildGoModule rec {
  pname = "statping-ng";
  version = "v0.91.0";

  subPackages = [
    "cmd/"
  ];
  src = fetchFromGitHub {
    owner = "statping-ng";
    repo = pname;
    rev = version;
    hash = "sha256-1jfllhy6/1SED9SEqtVQFF0i/K2POwM+kRhI9ZMFjvo=";
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
      moreutils
      jq
      python3
      faketty
      go
      git
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcbuild ];
    buildPhase = ''
      runHook preBuild
      export HOME="$(mktemp -d)"
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
    dontConfigure = true;
    dontCheckForBrokenSymlinks = true;
    dontInstall = false;
    dontFixup = true;
    outputHashMode = "recursive";
    doCheck = false;
    dontCheck = true;
    outputHashAlgo = "sha256";
    outputHash =
      {
        x86_64-linux = "sha256-7NsGcogpLE9sTbaG3M0I72dp4z1r5MaJ6tzCbHHDnac=";
        aarch64-linux = "sha256-HJWsWhkF+Eq24vZHcLWFCj/qxpx5Jc+dstlE1MCr4Iw=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };
  disallowedRequisites = [ offlineCache ];
  vendorHash = "sha256-ZcNOI5/Fs7/U8/re89YpJ3qlMaQStLrrNHXiHuBQwQk=";
  proxyVendor = true;
  nativeBuildInputs = [
    go-rice
    go
    git
    yarn
    nodejs
    webpack-cli
    removeReferencesTo
    faketty
    tzdata
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild.xcbuild ];
  postConfigure = ''
    # Help node-gyp find Node.js headers
    # (see https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#pitfalls-javascript-yarn2nix-pitfalls)
    export HOME="$(mktemp -d)"
    cp -r ${offlineCache}/node_modules frontend/
    chmod +w frontend/node_modules
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}
    cd frontend
    yarn config set enableTelemetry 0
    yarn config set cacheFolder $offlineCache
    yarn install --immutable-cache --offline
    export NODE_OPTIONS=--max_old_space_size=4096
    cd -
  '';
  postBuild = ''
    cd frontend
    #yarn local build
    NODE_OPTIONS=--openssl-legacy-provider NODE_ENV=production webpack --mode production
    cd ..
    cp -r frontend/dist source
    cp -r frontend/src/assets/scss source/dist
    cp -r frontend/public/robots.txt source/dist
    cd source && rice embed-go && cd -
    go build -a -ldflags "-s -w -X main.VERSION=${version}" -o statping-ng --tags "netgo osusergo" ./cmd
  '';
  postInstall = ''
    mkdir -p $out/bin
    cp statping-ng $out/bin/
    rm $out/bin/cmd
  '';
  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];
  preCheck = ''
    export ZONEINFO=${tzdata}/share/zoneinfo
  '';
  passthru.tests = {
    inherit (nixosTests) statping-ng;
    version = testers.testVersion {
      command = "statping version";
      package = statping-ng;
    };
  };
  checkPhase = '''';
  postFixup = ''
    while read line; do
      remove-references-to -t $offlineCache "$line"
    done < <(find $out -type f -name '*.js.map' -or -name '*.js')
  '';
  meta = with lib; {
    description = "An updated drop-in for statping. A Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins. Run on any type of environment.";
    homepage = "https://github.com/statping-ng/statping-ng";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      FKouhai
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "statping-ng";
  };
}
