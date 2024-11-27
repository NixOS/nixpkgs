{ lib
, buildGoModule
, fetchFromGitLab
, installShellFiles
}:

buildGoModule rec {
  pname = "meek";
  version = "0.38.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "meek";
    rev = "v${version}";
    sha256 = "sha256-zmIRXrHWrEzR+RcX/gkuqw2oBmyGoXDQ45ZjA4vwGSs=";
  };

  vendorHash = "sha256-eAO6vEPKqWWZkmJXmOCeTa7TE8opynYvvxzPDSe9p+I=";

  subPackages = [
    "meek-client"
    "meek-server"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/meek-client.1
    installManPage doc/meek-server.1
  '';

  meta = with lib; {
    description = "Blocking-resistant pluggable transport for Tor";
    longDescription = ''
      meek is a blocking-resistant pluggable transport for Tor. It encodes a
      data stream as a sequence of HTTPS requests and responses. Requests are
      reflected through a hard-to-block third-party web server in order to
      avoid talking directly to a Tor bridge. HTTPS encryption hides
      fingerprintable byte patterns in Tor traffic.
    '';
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/meek";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.cc0;
  };
}
