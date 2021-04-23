{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
, bash
}:

buildGoModule rec {
  pname = "umoci";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "0in8kyi4jprvbm3zsl3risbjj8b0ma62yl3rq8rcvcgypx0mn7d4";
  };

  vendorSha256 = null;

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ go-md2man installShellFiles ];

  postInstall = ''
    substituteInPlace Makefile --replace \
      '$(shell which bash)' '${lib.getBin bash}/bin/bash'
    make docs
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "umoci modifies Open Container images";
    homepage = "https://umo.ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.unix;
  };
}
