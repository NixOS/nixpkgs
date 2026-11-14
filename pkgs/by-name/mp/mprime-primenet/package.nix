{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gmp,
}:

# This package provides patched versions of release builds instead of building
# from source because mprime can only be used to run workers for primenet
# using the official mprime release builds. Binaries of mprime built from
# source are only capable of local operation.

let

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  # The newest official build for each platform. Mac builds are published less
  # often than Linux ones, so the two versions can differ.
  release =
    {
      "x86_64-linux" = {
        version = "31.07b02";
        target = "linux64";
        sha256 = "d275ffa06e826bc84aa6f97f7bd3cd342794b80c0b4f9a73022da85a0b35f3b1";
      };
      "x86_64-darwin" = {
        version = "31.04b04";
        target = "MacOSX";
        sha256 = "237d0b5826d24bbb29583c8ad87565865a00af5085cd267a162b4b35c5a8b960";
      };
    }
    ."${stdenv.hostPlatform.system}" or throwSystem;

  inherit (release) version target sha256;

  # "31.07b02" -> "31.07", the directory the build is published in.
  minorVersion = lib.head (lib.splitString "b" version);
  majorVersion = lib.head (lib.splitString "." version);

  tarballName = "p95v${lib.replaceStrings [ "." ] [ "" ] version}.${target}.tar.gz";

  tarball = fetchurl {
    url = "https://download.mersenne.ca/gimps/v${majorVersion}/${minorVersion}/${tarballName}";
    inherit sha256;
  };

in

stdenv.mkDerivation {
  pname = "mprime-primenet";
  inherit version;

  # src handled in non-standard way to allow for the hashes for fetchurl of the
  # tarballs to match the checksums published on mersenne.org
  src = tarball;
  unpackPhase = ''
    cp $src $(echo $src | cut --delimiter=- --fields=2-)
  '';

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    gmp
  ];

  buildPhase = ''
    runHook preBuild

    tar -xf ${tarballName}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -D mprime $out/bin/mprime
    install -m644 -D -t $out/share/doc/mprime readme.txt undoc.txt whatsnew.txt stress.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mersenne prime search / System stability tester";
    longDescription = ''
      MPrime is the Linux command-line interface version of Prime95, to be run
      in a text terminal or in a terminal emulator window as a remote shell
      client. It is identical to Prime95 in functionality, except it lacks a
      graphical user interface.
    '';
    homepage = "https://www.mersenne.org/";
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable prime. http://www.mersenne.org/legal/#EULA
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "mprime";
  };
}
