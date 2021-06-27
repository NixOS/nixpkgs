{ lib, stdenv, requireFile, bc }:

let
  license_dir = "~/.config/houdini";
in
stdenv.mkDerivation rec {
  version = "18.0.460";
  pname = "houdini-runtime";
  src = requireFile rec {
    #name = "houdini-py3-${version}-linux_x86_64_gcc6.3.tar.gz";
    #sha256 = "10qp8nml1ivl0syh0iwzx3zdwdpilnwakax50wydcrzdzyxza7xw"; # 18.5.621
    #sha256 = "1b1k7rkn7svmciijqdwvi9p00srsf81vkb55grjg6xa7fgyidjx1"; # 18.5.596
    name = "houdini-${version}-linux_x86_64_gcc6.3.tar.gz";
    sha256 = "18rbwszcks2zfn9zbax62rxmq50z9mc3h39b13jpd39qjqdd3jsd"; # 18.0.460
    url = meta.homepage;
  };

  buildInputs = [ bc ];
  installPhase = ''
    patchShebangs houdini.install
    mkdir -p $out
    sed -i "s|/usr/lib/sesi|${license_dir}|g" houdini.install
    ./houdini.install --install-houdini \
                      --no-install-menus \
                      --no-install-bin-symlink \
                      --auto-install \
                      --no-root-check \
                      --accept-EULA \
                      $out
    echo -e "localValidatorDir = ${license_dir}\nlicensingMode = localValidator" > $out/houdini/Licensing.opt
    sed -i "s|/usr/lib/sesi|${license_dir}|g" $out/houdini/sbin/sesinetd_safe
    sed -i "s|/usr/lib/sesi|${license_dir}|g" $out/houdini/sbin/sesinetd.startup
  '';
  meta = with lib; {
    description = "3D animation application software";
    homepage = "https://www.sidefx.com";
    license = licenses.unfree;
    platforms = platforms.linux;
    hydraPlatforms = [ ]; # requireFile src's should be excluded
    maintainers = with maintainers; [ canndrew kwohlfahrt ];
  };
}
