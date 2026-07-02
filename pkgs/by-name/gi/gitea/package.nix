{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  git,
  bash,
  coreutils,
  compressDrvWeb,
  gitea,
  gzip,
  nodejs,
  openssh,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  stdenv,
  sqliteSupport ? true,
  nixosTests,
}:

let
  pnpm = pnpm_10;

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "gitea-frontend";
    inherit (gitea) src version;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-Qo0DLuZv+2GVLsBfCv/6CC9E/qhSE4HwV4StQL4HX4Y=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      make frontend
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out/
    '';
  });
in
buildGoModule rec {
  pname = "gitea";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${gitea.version}";
    hash = "sha256-S7KV7soOnVQbw+2Ru7+DOL3Q4uWmSSdR6K90yofQlqw=";
  };

  proxyVendor = true;

  vendorHash = "sha256-7+M1n8RSgB3gZ/2na4RF9kYOf90H0bnsJZMDKpgAy64=";

  outputs = [
    "out"
    "data"
  ];

  patches = [ ./static-root-path.patch ];

  # go-modules derivation doesn't provide $data
  # so we need to wait until it is built, and then
  # at that time we can then apply the substituteInPlace
  overrideModAttrs = _: {
    postPatch = ''
      substituteInPlace go.mod \
        --replace-fail "go 1.26.3" "go 1.26"
    '';
  };

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
    substituteInPlace go.mod \
      --replace-fail "go 1.26.3" "go 1.26"
  '';

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  tags = lib.optionals sqliteSupport [
    "sqlite"
    "sqlite_unlock_notify"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  postInstall = ''
    mkdir $data
    ln -s ${frontend}/public $data/public
    cp -R ./{templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale

    wrapProgram $out/bin/gitea \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          git
          gzip
          openssh
        ]
      }
  '';

  passthru = {
    data-compressed =
      lib.warn "gitea.passthru.data-compressed is deprecated. Use \"compressDrvWeb gitea.data\"."
        (compressDrvWeb gitea.data { });

    tests = nixosTests.gitea;
  };

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      techknowlogick
      SuperSandro2000
    ];
    mainProgram = "gitea";
  };
}
