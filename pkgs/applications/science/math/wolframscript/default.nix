{ stdenv, requireFile, dpkg, glibc, gcc-unwrapped, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "wolframscript";
  version = "12.1.0";

  src = requireFile rec {
    name = "WolframScript_${version}_LINUX64_amd64.deb";
    message = ''
      This nix expression requires that ${name} is
      already part of the store. Download file from wolfram website
      https://account.wolfram.com/products/downloads/wolframscript
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "397b67fd1879c6009d23b40c55a43ff104a7253abb87de221faeeb374765aca1";
  };

  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  buildInputs = [
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out $out/share/wolframscript

    # install binaries
    dpkg --fsys-tarfile $src | \
      tar --strip-components=4 -xv -C $out ./opt/Wolfram/WolframScript

    # install share folder
    dpkg --fsys-tarfile $src | \
      tar --strip-components=3 -xv -C $out/share/wolframscript ./usr/share
  '';

  meta = with stdenv.lib; {
    description = "WolframScript enables Wolfram Language code to be run from any terminal";
    homepage = https://www.wolfram.com/wolframscript/;
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    platforms = [ "x86_64-linux" ];
  };
}
