{
  lib,
  fetchurl,
  fetchFromGitea,
  buildGoModule,
  nixosTests,
}:
let
  domain = "codeberg.org";
  owner = "superseriousbusiness";
  repo = "gotosocial";

  version = "0.19.1";

  web-assets = fetchurl {
    url = "https://${domain}/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-UtxFm8ZSpIGXruBdanSF1lkA7Gs1FJNhoqzDTqSNYUM=";
  };
in
buildGoModule rec {
  inherit version;
  pname = repo;

  src = fetchFromGitea {
    inherit domain owner repo;
    tag = "v${version}";
    hash = "sha256-RhJRdRxTdbZwIAGD3gH0mjDfCvdS7xkRxcUd1ArsNoo=";
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

  meta = with lib; {
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
    maintainers = with maintainers; [ blakesmith ];
    license = licenses.agpl3Only;
  };
}
