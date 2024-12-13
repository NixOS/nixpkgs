{
  lib,
  stdenv,
  fetchurl,
  curl,
  tzdata,
  autoPatchelfHook,
  fixDarwinDylibNames,
  glibc,
  version,
  hashes,
}:

let
  inherit (stdenv) hostPlatform;
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  MODEL = toString hostPlatform.parsed.cpu.bits;
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
    sha256 = hashes.${OS} or (throw "missing bootstrap sha256 for OS ${OS}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs =
    lib.optionals hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];
  propagatedBuildInputs =
    [
      curl
      tzdata
    ]
    ++ lib.optionals hostPlatform.isLinux [
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
    platforms = [
      "x86_64-darwin"
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
