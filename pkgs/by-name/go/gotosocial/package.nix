{
  lib,
  fetchurl,
  fetchFromCodeberg,
  buildGo124Module,
  nixosTests,
}:
let
  owner = "superseriousbusiness";
  repo = "gotosocial";

  version = "0.20.3";

  web-assets = fetchurl {
    url = "https://codeberg.org/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-Xh4SgzBG2Cm4SaMb9lebW/gBv94HuVXNSjd8L+bowUg=";
  };
in
buildGo124Module rec {
  inherit version;
  pname = repo;

  src = fetchFromCodeberg {
    inherit owner repo;
    tag = "v${version}";
    hash = "sha256-tWICsPN9r3mJqcs0EHE1+QFhQCzI1pD1eXZXSi2Peo4=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [
    "kvformat"
  ];

  postInstall = ''
    tar xf ${web-assets}
    mkdir -p $out/share/gotosocial
    mv web $out/share/gotosocial/
  '';

  # tests are working only on x86_64-linux
  # doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;
  # checks are currently very unstable in our setup, so we should test manually for now
  doCheck = false;

  checkFlags =
    let
      # flaky / broken tests
      skippedTests = [
        # See: https://github.com/superseriousbusiness/gotosocial/issues/2651
        "TestPage/minID,_maxID_and_limit_set"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests.gotosocial = nixosTests.gotosocial;

  meta = {
    homepage = "https://gotosocial.org";
    changelog = "https://codeberg.org/superseriousbusiness/gotosocial/releases/tag/v${version}";
    description = "Fast, fun, ActivityPub server, powered by Go";
    longDescription = ''
      ActivityPub social network server, written in Golang.
      You can keep in touch with your friends, post, read, and
      share images and articles. All without being tracked or
      advertised to! A light-weight alternative to Mastodon
      and Pleroma, with support for clients!
    '';
    maintainers = with lib.maintainers; [
      blakesmith
      cherrykitten
    ];
    license = lib.licenses.agpl3Only;
  };
}
