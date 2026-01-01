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
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pnpm,
  stdenv,
  sqliteSupport ? true,
  nixosTests,
}:

let
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "gitea-frontend";
    inherit (gitea) src version;

<<<<<<< HEAD
    pnpmDeps = fetchPnpmDeps {
=======
    pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-0p7P68BvO3hv0utUbnPpHSpGLlV7F9HHmOITvJAb/ww=";
    };

    nativeBuildInputs = [
      nodejs
<<<<<<< HEAD
      pnpmConfigHook
      pnpm
=======
      pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "1.25.3";
=======
  version = "1.25.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    tag = "v${gitea.version}";
<<<<<<< HEAD
    hash = "sha256-jCh4CuVS/WHpd1+NLfB3Sc2sonVcfedDZAgYTqcXZaU=";
=======
    hash = "sha256-8U7zRZoiuB2+LLeOg2QpCuxWRNkndlp/VyH1OvnZujc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  proxyVendor = true;

  vendorHash = "sha256-y7HurJg+/V1cn8iKDXepk/ie/iNgiJXsQbDi1dhgark=";

  outputs = [
    "out"
    "data"
  ];

  patches = [ ./static-root-path.patch ];

  # go-modules derivation doesn't provide $data
  # so we need to wait until it is built, and then
  # at that time we can then apply the substituteInPlace
  overrideModAttrs = _: { postPatch = null; };

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
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

<<<<<<< HEAD
  meta = {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Git with a cup of tea";
    homepage = "https://about.gitea.com";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      techknowlogick
      SuperSandro2000
    ];
    mainProgram = "gitea";
  };
}
