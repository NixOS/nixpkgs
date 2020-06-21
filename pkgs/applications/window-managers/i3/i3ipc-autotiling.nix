{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "i3ipc-autotiling";
  version = "d521cd6d26d0b3aadbd283fe4165235b5df386f2";
  src = fetchTarball {
    name = pname;
    url = "https://github.com/nwg-piotr/autotiling/archive/${version}.tar.gz";
     # Hash obtained using `nix-prefetch-url --unpack <url>`
     sha256 = "1lz1fasm4586vw9y0hdl2fn56swb7jbsgi71n1jwdfl3bnhawv0s";
   };
   propagatedBuildInputs = [ python3Packages.i3ipc ];

   dontBuild = true;
   doCheck = false;
   installPhase = ''
    mkdir -p "$out/bin"
    cp autotiling.py "$out/bin/autotiling"'';
   postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/${pname}-python-interpreter
    '';
   meta = with lib; {
     homepage = https://github.com/nwg-piotr/autotiling;
     description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
     license = licenses.gpl3;
     maintainers = with maintainers; [ nwg-piotr ];
   };
 }
