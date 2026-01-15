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

  version = "30.19b14";

  target =
    {
      "x86_64-linux" = "linux64";
      "x86_64-darwin" = "MacOSX";
    }
    ."${stdenv.hostPlatform.system}" or throwSystem;

  sha256 =
    {
      "x86_64-linux" = "ccd48d2ceebfe583003dbf8ff1dca8d744e98bf7ed4124e482bd6a3a06eaf507";
      "x86_64-darwin" = "520dbf6e6dbd6184626bfae02e8e2d8ba4d4ab081d138a73a3852f08ece1ea6a";
    }
    ."${stdenv.hostPlatform.system}" or throwSystem;

  tarballName = "p95v${lib.replaceStrings [ "." ] [ "" ] version}.${target}.tar.gz";

  tarball = fetchurl {
    url = "https://www.mersenne.org/download/software/v30/30.19/${tarballName}";
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
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "mprime";
  };
}
