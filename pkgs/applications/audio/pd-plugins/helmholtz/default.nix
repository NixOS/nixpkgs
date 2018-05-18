{ stdenv, fetchurl, unzip, puredata }:

stdenv.mkDerivation rec {
  name = "helmholtz";

  src = fetchurl {
    url = "http://www.katjaas.nl/helmholtz/helmholtz~.zip";
    name = "helmholtz.zip";
    curlOpts = "--user-agent ''";
    sha256 = "0h1fj7lmvq9j6rmw33rb8k0byxb898bi2xhcwkqalb84avhywgvs";
  };

  buildInputs = [ unzip puredata ];

  unpackPhase = ''
    unzip $src
    mv helmholtz~/src/helmholtz\~.cpp .
    mv helmholtz~/src/Helmholtz.cpp .
    mv helmholtz~/src/include/ .
    mv helmholtz~/src/Makefile .
    rm -rf helmholtz~/src/
    rm helmholtz~/helmholtz~.pd_darwin
    rm helmholtz~/helmholtz~.pd_linux
    rm helmholtz~/helmholtz~.dll
    rm -rf __MACOSX
  '';

  patchPhase = ''
    mkdir -p $out/helmholtz~
    sed -i "s@current: pd_darwin@current: pd_linux@g" Makefile
    sed -i "s@-Wl@@g" Makefile
    sed -i "s@\$(NAME).pd_linux \.\./\$(NAME).pd_linux@helmholtz~.pd_linux $out/helmholtz~/@g" Makefile
  '';

  installPhase = ''
    cp -r helmholtz~/ $out/
  '';

  meta = {
    description = "Time domain pitch tracker for Pure Data";
    homepage = http://www.katjaas.nl/helmholtz/helmholtz.html;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
