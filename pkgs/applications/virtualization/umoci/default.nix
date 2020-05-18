{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
}:

buildGoModule rec {
  pname = "umoci";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "1gzj4nnys73wajdwjn5jsskvnhzh8s2vmyl76ax8drpvw19bd5g3";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ go-md2man installShellFiles ];

  postInstall = ''
    sed -i '/SHELL =/d' Makefile
    make local-doc
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "umoci modifies Open Container images";
    homepage = "https://umo.ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.linux;
  };
}
