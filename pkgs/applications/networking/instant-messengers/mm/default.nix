{ stdenv, buildGoModule, fetchgit }:

buildGoModule {
  pname = "mm";
  version = "2020.11.17";

  src = fetchgit {
    url = "https://git.lost.host/meutraa/mm.git";
    rev = "e5fa8eeb845aac8f28fc36013ee8a1dbe1e5710c";
    sha256 = "sha256-SdD4EE/rc85H7xqKB/kU8XFsC63i1sVObPha/zrxFGk=";
  };

  vendorSha256 = "sha256-zJJ9PzQShv2iRNyCg1XVscbwjV9ZtMIojJDtXXm3rVM=";

  meta = with stdenv.lib; {
    description = "A file system based matrix client";
    homepage = "https://git.lost.host/meutraa/mm";
    license = licenses.isc;
    maintainers = with maintainers; [ meutraa ];
  };
}
