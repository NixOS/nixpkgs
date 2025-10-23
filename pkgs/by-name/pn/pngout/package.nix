{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let
  platforms = {
    aarch64-darwin = {
      folder = ".";
    };
    aarch64-linux = {
      folder = "aarch64";
      ld-linux = "ld-linux-aarch64.so.1";
    };
    armv7l-linux = {
      folder = "armv7";
      ld-linux = "ld-linux-armhf.so.3";
    };
    i686-linux = {
      folder = "i686";
      ld-linux = "ld-linux.so.2";
    };
    x86_64-darwin = {
      folder = ".";
    };
    x86_64-linux = {
      folder = "amd64";
      ld-linux = "ld-linux-x86-64.so.2";
    };
  };
  platform =
    platforms."${stdenv.hostPlatform.system}"
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  download =
    if stdenv.hostPlatform.isDarwin then
      {
        suffix = "20230322-mac.zip";
        hash = "sha256-Lj63k0UgYECuOg0NDs/prQHZL+UAK4oWdqZWMqVoQOE=";
      }
    else
      {
        suffix = "20200115-linux.tar.gz";
        hash = "sha256-rDi7pvDeKQM96GZTjDr6ZDQTGbaVu+OI77xf2egw6Sg=";
      };
in
stdenv.mkDerivation {
  pname = "pngout";
  version = "20230322";

  src = fetchurl {
    inherit (download) hash;
    url = "https://www.jonof.id.au/files/kenutils/pngout-${download.suffix}";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ unzip ];

  # pngout is code-signed on Darwin, so don’t alter the binary to avoid breaking the signature.
  dontFixup = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    mkdir -p $out/bin
    cp ${platform.folder}/pngout $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/${platform.ld-linux} $out/bin/pngout
  '';

  meta = {
    description = "Tool that aggressively optimizes the sizes of PNG images";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    homepage = "http://advsys.net/ken/utils.htm";
    platforms = lib.attrNames platforms;
    maintainers = [ lib.maintainers.sander ];
    mainProgram = "pngout";
  };
}
