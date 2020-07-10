{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
}:

buildGoModule rec {
  pname = "umoci";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "0jaar26l940yh77cs31c3zndiycp85m3fz4zivcibzi68g6n6yzg";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ go-md2man installShellFiles ];

  postInstall = ''
    sed -i '/SHELL =/d' Makefile
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
