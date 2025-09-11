{
  lib,
  pkgs ? import <nixpkgs> { },
}:
pkgs.python312Packages.buildPythonPackage {
  version = "0.2.2";
  pname = "audiomatch";
  format = "wheel";
  src = builtins.fetchurl {
    url = "https://files.pythonhosted.org/packages/3b/ae/0386e70df1ebfd27962c395dc1ac2f19c0c93d9536c098ee1178a714bb05/audiomatch-0.2.2-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl";
    sha256 = "1fjjzpgng19alv4q5kqqx2vc40vc2v4mrjrf1hrslhc7ni1xlkn7";
  };

  meta = {
    homepage = "https://github.com/unmade/audiomatch";
    description = "A small command-line tool to find similar audio files";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "audiomatch";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
}
