{ lib, stdenv, requireFile, bc }:

let
  license_dir = "~/.config/houdini";
in
stdenv.mkDerivation rec {
  version = "19.5.569";
  pname = "houdini-runtime";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc9.3.tar.gz";
    sha256 = "0c2d6a31c24f5e7229498af6c3a7cdf81242501d7a0792e4c33b53a898d4999e";
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
                      --accept-EULA 2021-10-13 \
                      $out
    echo "licensingMode = localValidator" >> $out/houdini/Licensing.opt  # does not seem to do anything any more. not sure, official docs do not say anything about it
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
