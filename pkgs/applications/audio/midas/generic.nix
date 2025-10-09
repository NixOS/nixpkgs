{
  stdenv,
  fetchurl,
  lib,
  brand,
  type,
  version,
  homepage,
  url,
  hash,
  runCommand,
  dpkg,
  vmTools,
  runtimeShell,
  bubblewrap,
  ...
}:
let
  debian =
    let
      debs = lib.flatten (import ./deps.nix { inherit fetchurl; });
    in
    runCommand "x32edit-debian" { nativeBuildInputs = [ dpkg ]; } (
      lib.concatMapStringsSep "\n" (deb: ''
        dpkg-deb -x ${deb} $out
      '') debs
    );
in
stdenv.mkDerivation rec {
  pname = "${lib.toLower type}-edit";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${type}-Edit $out/bin/.${pname}

    cat >$out/bin/${pname} <<EOF
    #!${runtimeShell} -eu
    exec ${lib.getExe bubblewrap} \
      --dev-bind / / \
      --ro-bind "${debian}/lib" /lib \
      --ro-bind "${debian}/lib64" /lib64 \
      --tmpfs /usr \
      --ro-bind "${debian}/usr/lib" /usr/lib \
      $out/bin/.${pname}
    EOF
    chmod 755 $out/bin/${pname}
  '';

  passthru.deps =
    let
      distro = vmTools.debDistros.debian12x86_64;
    in
    vmTools.debClosureGenerator {
      name = "x32edit-dependencies";
      inherit (distro) urlPrefix;
      packagesLists = [ distro.packagesList ];
      packages = [
        "libstdc++6"
        "libcurl4"
        "libfreetype6"
        "libasound2"
        "libx11-6"
        "libxext6"
      ];
    };

  meta = with lib; {
    inherit homepage;
    description = "Editor for the ${brand} ${type} digital mixer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
