{
  lib,
  stdenv,
  fetchurl,
  unzip,
  puredata,
}:

stdenv.mkDerivation {
  name = "helmholtz";

  src = fetchurl {
    url = "https://www.katjaas.nl/helmholtz/helmholtz~.zip";
    name = "helmholtz.zip";
    curlOpts = "--user-agent ''";
    sha256 = "0h1fj7lmvq9j6rmw33rb8k0byxb898bi2xhcwkqalb84avhywgvs";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ puredata ];

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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Time domain pitch tracker for Pure Data";
    homepage = "http://www.katjaas.nl/helmholtz/helmholtz.html";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
