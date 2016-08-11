{ stdenv, fetchurl, pkgs, callPackage, vstsdk, gnused }:

let
  wine32 = 
      (callPackage ../../../misc/emulators/wine {
          wineRelease = "unstable";
          wineBuild = "wine32";
      });
  wine64 = 
      (callPackage ../../../misc/emulators/wine {
          wineRelease = "unstable";
          wineBuild = "wine64";
      });
in
stdenv.mkDerivation rec {
  name = "airwave-${version}";
  version = "1.2.1";
  src = fetchurl {
    url = "https://github.com/phantom-code/airwave/archive/${version}.tar.gz";
    sha256 = "1smwaggqk3aim9mknf7ahm4zpsrgqn8j18ivwyflnhvhpdrahqh6";
  };
  cmakeFlags = [ "-DVSTSDK_PATH=${vstsdk}" ];
  # Fixes linking error for airwave-host-64:
  preBuild = ''
    ${gnused}/bin/sed -i src/host/CMakeFiles/airwave-host-64.dir/link.txt \
      -e "s#wineg++#${wine64}/bin/wineg++#"
  '';
  buildInputs = with pkgs; [ 
      cmake 
      file
      gcc_multi
      glibc_multi
      qt5Full
      wine32
      wine64
      x11
  ];
  meta = with stdenv.lib; {
    homepage = https://github.com/phantom-code/airwave;
    description = "WINE-based VST bridge";
    license = licenses.mit;
    maintainers = [ maintainers.joelmo ];
  };
}
