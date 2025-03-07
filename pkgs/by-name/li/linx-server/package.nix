{
  buildGoModule,
  fetchFromGitHub,
  go-rice,
  lib,
}:

buildGoModule rec {
  pname = "linx-server";
  version = "unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "zizzydizzymc";
    repo = pname;
    rev = "3f503442f10fca68a3212975b23cf74d92c9988c";
    hash = "sha256-tTHw/rIb2Gs5i5vZKsSgbUePIY7Np6HofBXu4TTjKbw=";
  };

  # upstream tests are broken, see zizzydizzymc/linx-server#34
  patches = [ ./test.patch ];

  vendorHash = "sha256-/N3AXrPyENp3li4X86LNXsfBYbjJulk+0EAyogPNIpc=";

  nativeBuildInputs = [ go-rice ];

  preBuild = "rice embed-go";

  meta = with lib; {
    description = "Self-hosted file/code/media sharing website";
    homepage = "https://put.icu";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
