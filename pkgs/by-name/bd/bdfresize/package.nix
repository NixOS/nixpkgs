{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "bdfresize";
  version = "1.5";

  src = fetchurl {
    url = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/bdfresize-${version}.tar.gz";
    hash = "sha256-RAz8BiCgI35GNSwUoHdMqj8wWXWbCiDe/vyU6EkIl6Y=";
  };

  patches = [ ./remove-malloc-declaration.patch ];

  meta = with lib; {
    description = "Tool to resize BDF fonts";
    homepage = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ malte-v ];
    mainProgram = "bdfresize";
  };
}
