{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, srht
, redis
, celery
, pyyaml
, markdown
, ansi2html
, python
}:
let
  version = "0.74.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "builds.sr.ht";
    rev = version;
    sha256 = "sha256-vdVKaI42pA0dnyMXhQ4AEaDgTtKcrH6hc9L6PFcl6ZA=";
  };

  worker = buildGoModule {
    inherit src version;
    sourceRoot = "source/worker";
    pname = "buildsrht-worker";

    vendorSha256 = "sha256-7zlt5305P3KzGrs4wUyAU1+FpoBMyl+yjkLSzqUybxg=";

    # What follows is only to update go-redis,
    # and thus also using a patched srht-keys.
    # go.{mod,sum} could be patched directly but that would be less resilient
    # to changes from upstream, and thus harder to maintain the patching
    # while it hasn't been merged upstream.

    overrideModAttrs = old: {
      preBuild = ''
        go get github.com/go-redis/redis/v8
        go get github.com/go-redis/redis@none
        go mod tidy
      '';
      # Pass updated go.{mod,sum} from go-modules to worker's vendor/go.{mod,sum}
      postInstall = ''
        cp --reflink=auto go.* $out/
      '';
    };

    patches = [
      # Update go-redis to support Unix sockets
      patches/redis-socket/build/v3-0001-worker-update-go-redis-to-support-Unix-sockets.patch
    ];
    patchFlags = ["-p2"];
    postConfigure = ''
      cp -v vendor/go.{mod,sum} .
    '';
  };
in
buildPythonPackage rec {
  inherit src version;
  pname = "buildsrht";

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    celery
    pyyaml
    markdown
    ansi2html
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/lib
    mkdir -p $out/bin/builds.sr.ht

    cp -r images $out/lib
    cp contrib/submit_image_build $out/bin/builds.sr.ht
    cp ${worker}/bin/worker $out/bin/builds.sr.ht-worker
  '';

  pythonImportsCheck = [ "buildsrht" ];

  passthru = { inherit worker; };

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/builds.sr.ht";
    description = "Continuous integration service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}
