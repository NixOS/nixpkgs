{
  buildNpmPackage,
  cctools,
  fetchFromGitHub,
  fetchpatch,
  lib,
  node-gyp,
  nodejs,
  python3,
  stdenv,
}:

buildNpmPackage {
  pname = "nodehun";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Wulf";
    repo = "nodehun";
    rev = "03c9dcf1fcd965031a68553ccaf6487d1fe87f79";
    hash = "sha256-MoY95lSIQK1K4aIlMdPm93YxJuez9HYx2zlUhHvDao0=";
  };

  patches = [
    (fetchpatch {
      name = "remove-nodemon.patch";
      url = "https://github.com/Wulf/nodehun/commit/63ab4e441b0864f0bf2fb257a108d9b029a7ae9e.patch?full_index=1";
      hash = "sha256-gR4GThzb92Rw5W5Nrb6lM3pwg3dh0JgV2au//clom7g=";
    })
  ];

  npmDepsHash = "sha256-Dju67cL5/Q5TcStvON5Kfx9rDX61ClhBwIXVacWDnUc=";
  nativeBuildInputs = [
    node-gyp
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  postInstall = ''
    # Only keep the necessary parts of build/Release to reduce closure size
    cd $out/lib/node_modules/nodehun
    mv build build_old
    mkdir build
    cp -r build_old/Release build/
    rm -rf build_old
    rm -rf build/Release/.deps

    # Remove a development script to eliminate runtime dependency on node
    rm node_modules/node-addon-api/tools/conversion.js

    # Remove dangling symlinks
    rm -rf $out/lib/node_modules/nodehun/node_modules/.bin
  '';

  doInstallCheck = true;
  nativeCheckInputs = [ nodejs ];
  postInstallCheck = ''
    # Smoke check: require() works
    export NODE_PATH=$out/lib/node_modules
    echo 'require("nodehun")' | node -
  '';

  disallowedReferences = [ nodejs ];

  meta = {
    description = "Hunspell binding for NodeJS that exposes as much of Hunspell as possible and also adds new features";
    homepage = "https://github.com/Wulf/nodehun";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thomasjm ];
  };
}
