{
  lib,
  symlinkJoin,
  pkgsi686Linux,
}:
let
  python = pkgsi686Linux.python311;
in
symlinkJoin {
  pname = "millennium-python";
  inherit (python) version;
  paths = [ python ];

  postBuild = ''
    mkdir -p $out/lib
    ln -s ${python}/lib/libpython3.11.so.1.0 $out/lib/libpython-3.11.8.so
  '';

  meta = {
    homepage = "https://steambrew.app/";
    license = lib.licenses.mit;
    description = "Python 3.11 environment for Millennium";

    maintainers = with lib.maintainers; [
      trivaris
    ];

    platforms = [
      "x86_64-linux"
    ];
  };
}
