{ lib
, stdenv
, buildNpmPackage
, nodejs_20
, fetchFromGitHub
, python3
, cctools
, nix-update-script
, nixosTests
, xcbuild
}:

buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.9.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-o5nRG2j73qheDOyeFfSga64D8HbTn1EUrCiN0W+Xn0w=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  nodejs = nodejs_20;

  npmDepsHash = "sha256-L7/frKCNlq0xr6T+aSqyEQ44yrIXwcpdU/djrhCJNNk=";

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ setuptools ]))
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild.xcrun
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  # node-argon2 builds with LTO, but that causes missing symbols. So disable it
  # and rebuild. See https://github.com/ranisalt/node-argon2/pull/415
  preConfigure = ''
    pushd node_modules/argon2
    substituteInPlace binding.gyp --replace-fail '"-flto", ' ""
    "$npm_config_node_gyp" rebuild
    popd
  '';

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  passthru = {
    tests = {
      vaultwarden = nixosTests.vaultwarden.sqlite;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--commit" "--version=stable" "--version-regex=^cli-v(.*)$" ];
    };
  };

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
