{ lib
, stdenv
, fetchurl
, curl
, tzdata
, autoPatchelfHook
, fixDarwinDylibNames
, glibc
}:

let
  inherit (stdenv) hostPlatform;
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  MODEL = toString hostPlatform.parsed.cpu.bits;

  version = "2.090.1";
  hashes = {
    # Get these from `nix-prefetch-url http://downloads.dlang.org/releases/2.x/2.090.1/dmd.2.090.1.linux.tar.xz` etc..
    osx = "sha256-9HwGVO/8jfZ6aTiDIUi8w4C4Ukry0uUS8ACP3Ig8dmU=";
    linux = "sha256-ByCrIA4Nt7i9YT0L19VXIL1IqIp+iObcZux407amZu4=";
  };
in

# On linux pargets like `pkgsLLVM.dmd` `cc` does not expose `libgcc`
# and can't build `dmd`.
assert hostPlatform.isLinux -> (stdenv.cc.cc ? libgcc);
stdenv.mkDerivation {
  pname = "dmd-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "dmd.${version}.${OS}.tar.xz";
    url = "http://downloads.dlang.org/releases/2.x/${version}/${name}";
    hash = hashes.${OS} or (throw "missing bootstrap hash for OS ${OS}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals hostPlatform.isLinux [
    autoPatchelfHook
  ] ++ lib.optionals hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];
  propagatedBuildInputs = [
    curl
    tzdata
  ] ++ lib.optionals hostPlatform.isLinux [
    glibc
    stdenv.cc.cc.libgcc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # try to copy model-specific binaries into bin first
    mv ${OS}/bin${MODEL} $out/bin || true

    mv src license.txt ${OS}/* $out/

    # move man into place
    mkdir -p $out/share
    mv man $out/share/

    # move docs into place
    mkdir -p $out/share/doc
    mv html/d $out/share/doc/

    # fix paths in dmd.conf (one level less)
    substituteInPlace $out/bin/dmd.conf --replace "/../../" "/../"

    runHook postInstall
  '';

  # Stripping on Darwin started to break libphobos2.a
  # Undefined symbols for architecture x86_64:
  #   "_rt_envvars_enabled", referenced from:
  #       __D2rt6config16rt_envvarsOptionFNbNiAyaMDFNbNiQkZQnZQq in libphobos2.a(config_99a_6c3.o)
  dontStrip = hostPlatform.isDarwin;

  meta = with lib; {
    description = "Digital Mars D Compiler Package";
    # As of 2.075 all sources and binaries use the boost license
    license = licenses.boost;
    maintainers = [ maintainers.lionello ];
    homepage = "https://dlang.org/";
    platforms = [ "x86_64-darwin" "i686-linux" "x86_64-linux" ];
  };
}
