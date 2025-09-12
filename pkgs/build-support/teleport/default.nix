{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  binaryen,
  cargo,
  libfido2,
  nodejs,
  openssl,
  pkg-config,
  pnpm_10,
  rustc,
  stdenv,
  xdg-utils,
  wasm-pack,
  nixosTests,
}:

{
  version,
  hash,
  cargoHash,
  pnpmHash,
  vendorHash,
  wasm-bindgen-cli,
  buildGoModule,

  withRdpClient ? true,
  extPatches ? [ ],
}:
let

  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    tag = "v${version}";
    inherit hash;
  };
  pname = "teleport";
  inherit version;

  rdpClient = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "teleport-rdpclient";
    inherit cargoHash;
    inherit version src;

    buildAndTestSubdir = "lib/srv/desktop/rdp/rdpclient";

    buildInputs = [ openssl ];
    nativeBuildInputs = [ pkg-config ];

    # https://github.com/NixOS/nixpkgs/issues/161570 ,
    # buildRustPackage sets strictDeps = true;
    nativeCheckInputs = finalAttrs.buildInputs;

    OPENSSL_NO_VENDOR = "1";

    postInstall = ''
      mkdir -p $out/include
      cp ${finalAttrs.buildAndTestSubdir}/librdpclient.h $out/include/
    '';
  });

  webassets = stdenv.mkDerivation {
    pname = "teleport-webassets";
    inherit src version;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = cargoHash;
    };

    pnpmDeps = pnpm_10.fetchDeps {
      inherit src pname version;
      fetcherVersion = 1;
      hash = pnpmHash;
    };

    nativeBuildInputs = [
      binaryen
      cargo
      nodejs
      pnpm_10.configHook
      rustc
      rustc.llvmPackages.lld
      rustPlatform.cargoSetupHook
      wasm-bindgen-cli
      wasm-pack
    ];

    patches = [
      ./disable-wasm-opt-for-ironrdp.patch
    ];

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      runHook postConfigure
    '';

    buildPhase = ''
      PATH=$PATH:$PWD/node_modules/.bin

      pushd web/packages
      pushd shared
      # https://github.com/gravitational/teleport/blob/6b91fe5bbb9e87db4c63d19f94ed4f7d0f9eba43/web/packages/teleport/README.md?plain=1#L18-L20
      RUST_MIN_STACK=16777216 wasm-pack build ./libs/ironrdp --target web --mode no-install
      popd
      pushd teleport
      vite build
      popd
      popd
    '';

    installPhase = ''
      mkdir -p $out
      cp -R webassets/. $out
    '';
  };
in
buildGoModule (finalAttrs: {
  inherit pname src version;
  inherit vendorHash;
  proxyVendor = true;

  subPackages = [
    "tool/tbot"
    "tool/tctl"
    "tool/teleport"
    "tool/tsh"
  ];
  tags = [
    "libfido2"
    "webassets_embed"
  ]
  ++ lib.optional withRdpClient "desktop_access_rdp";

  buildInputs = [
    openssl
    libfido2
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  patches = extPatches ++ [
    ./0001-fix-add-nix-path-to-exec-env.patch
    ./rdpclient.patch
    ./tsh.patch
  ];

  # Reduce closure size for client machines
  outputs = [
    "out"
    "client"
  ];

  preBuild = ''
    cp -r ${webassets} webassets
  ''
  + lib.optionalString withRdpClient ''
    ln -s ${rdpClient}/lib/* lib/
    ln -s ${rdpClient}/include/* lib/srv/desktop/rdp/rdpclient/
  '';

  # Multiple tests fail in the build sandbox
  # due to trying to spawn nixbld's shell (/noshell), etc.
  doCheck = false;

  postInstall = ''
    mkdir -p $client/bin
    mv {$out,$client}/bin/tsh
    # make xdg-open overrideable at runtime
    wrapProgram $client/bin/tsh --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    ln -s {$client,$out}/bin/tsh
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    export HOME=$(mktemp -d)
    $out/bin/tsh version | grep ${version} > /dev/null
    $client/bin/tsh version | grep ${version} > /dev/null
    $out/bin/tbot version | grep ${version} > /dev/null
    $out/bin/tctl version | grep ${version} > /dev/null
    $out/bin/teleport version | grep ${version} > /dev/null
  '';

  passthru.tests = nixosTests.teleport;

  meta = {
    description = "Certificate authority and access plane for SSH, Kubernetes, web applications, and databases";
    homepage = "https://goteleport.com/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      arianvp
      justinas
      sigma
      tomberek
      freezeboy
      techknowlogick
      juliusfreudenberger
    ];
    platforms = lib.platforms.unix;
    # go-libfido2 is broken on platforms with less than 64-bit because it defines an array
    # which occupies more than 31 bits of address space.
    broken = stdenv.hostPlatform.parsed.cpu.bits < 64;
  };
})
