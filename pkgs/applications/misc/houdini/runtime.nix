{ lib, stdenv, requireFile, bc }:

let
  license_dir = "~/.config/houdini";
in
stdenv.mkDerivation rec {
  version = "18.5.596";
  pname = "houdini-runtime";
  src = requireFile rec {
    name = "houdini-py3-${version}-linux_x86_64_gcc6.3.tar.gz";
    sha256 = "1b1k7rkn7svmciijqdwvi9p00srsf81vkb55grjg6xa7fgyidjx1";
    url = meta.homepage;
  };

  buildInputs = [ bc ];
  installPhase = ''
    patchShebangs houdini.install
    mkdir -p $out
    ./houdini.install --install-houdini \
                      --install-license \
                      --no-install-menus \
                      --no-install-bin-symlink \
                      --auto-install \
                      --no-root-check \
                      --accept-EULA 2020-05-05 \
                      $out
    echo "licensingMode = localValidator" >> $out/houdini/Licensing.opt
  '';

  dontFixup = true;

  meta = with lib; {
    description = "3D animation application software";
    homepage = "https://www.sidefx.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    hydraPlatforms = [ ]; # requireFile src's should be excluded
    maintainers = with maintainers; [ canndrew kwohlfahrt ];
  };
}
