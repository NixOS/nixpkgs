{ lib
, rustPlatform
, fetchFromGitHub
, pkgconfig
, openssl
, libredirect
, writeText
}:

rustPlatform.buildRustPackage rec {
  pname = "nym";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym";
    rev = "v${version}";
    sha256 = "1q9i24mzys6a9kp9n0bnxr3iwzblabmc6iif3ah75gffyf0cipk4";
  };

  cargoSha256 = "0qas544bs4wyllvqf2r5mvqxs1nviwcvxa3rzq10dvjyjm1xyh3k";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ];

  /*
  Nym's test presence::converting_mixnode_presence_into_topology_mixnode::it_returns_resolved_ip_on_resolvable_hostname tries to resolve nymtech.net.
  Since there is no external DNS resolution available in the build sandbox, we point cargo and its children (that's what we remove the 'unsetenv' call for) to a hosts file in which we statically resolve nymtech.net.
  */
  preCheck = ''
    export LD_PRELOAD=${libredirect.overrideAttrs (drv: {
      postPatch = "sed -i -e /unsetenv/d libredirect.c";
    })}/lib/libredirect.so
    export NIX_REDIRECTS=/etc/hosts=${writeText "nym_resolve_test_hosts" "127.0.0.1 nymtech.net"}
  '';

  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";


  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A mixnet providing IP-level privacy";
    longDescription = ''
      Nym routes IP packets through other participating nodes to hide their source and destination.
      In contrast with Tor, it prevents timing attacks at the cost of latency.
    '';
    homepage = "https://nymtech.net";
    license = licenses.asl20;
    maintainers = [ maintainers.ehmry ];
    platforms = with platforms; intersectLists (linux ++ darwin) (x86 ++ x86_64); # see https://github.com/nymtech/nym/issues/179 for architectures
  };
}
