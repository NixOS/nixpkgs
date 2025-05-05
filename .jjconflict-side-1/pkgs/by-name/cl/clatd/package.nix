{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
  tayga,
  iproute2,
  nftables,
  systemd,
  nixosTests,
}:

assert (lib.assertMsg systemd.withNetworkd "systemd for clatd must be built with networkd support");
stdenv.mkDerivation (finalAttrs: {
  pname = "clatd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "toreanderson";
    repo = "clatd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hNFuS6pdaA/FTIUeuwjGovlHcPh248Au1VXCzMuYwLU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    perl # for pod2man
  ];

  buildInputs = with perlPackages; [
    perl
    NetIP
    NetDNS
    JSON
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    mkdir -p $out/{sbin,share/man/man8}
  '';

  postFixup = ''
    patchShebangs $out/bin/clatd
    wrapProgram $out/bin/clatd \
      --set PERL5LIB $PERL5LIB \
      --prefix PATH : ${
        lib.makeBinPath [
          tayga # tayga
          iproute2 # ip
          nftables # nft
          systemd # networkctl
        ]
      }
  '';

  passthru.tests.clatd = nixosTests.clatd;

  meta = with lib; {
    description = "464XLAT CLAT implementation for Linux";
    homepage = "https://github.com/toreanderson/clatd";
    license = licenses.mit;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "clatd";
    platforms = platforms.linux;
  };
})
