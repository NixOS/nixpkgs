{
  lib,
  stdenv,
  binutils,
  fetchurl,
  ncurses5,
}:

stdenv.mkDerivation rec {
  version = "0.0.74";
  pname = "kythe";

  src = fetchurl {
    url = "https://github.com/kythe/kythe/releases/download/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "sha256-UqnG6BESNwQ7jQthJ2N/DrjSujp3bkdJsDbpEew1Kc4=";
  };

  buildInputs = [ binutils ];

  doCheck = false;

  dontBuild = true;

  installPhase = ''
    cd tools
    for exe in http_server \
                kythe read_entries triples verifier \
                write_entries write_tables entrystream; do
      echo "Patching:" $exe
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $exe
      patchelf --set-rpath "${
        lib.makeLibraryPath [
          stdenv.cc.cc
          ncurses5
        ]
      }" $exe
    done
    cd ../
    cp -R ./ $out
    ln -s $out/tools $out/bin
  '';

  meta = with lib; {
    description = "Pluggable, (mostly) language-agnostic ecosystem for building tools that work with code";
    longDescription = ''
      The Kythe project was founded to provide and support tools and standards
        that encourage interoperability among programs that manipulate source
        code. At a high level, the main goal of Kythe is to provide a standard,
        language-agnostic interchange mechanism, allowing tools that operate on
        source code — including build systems, compilers, interpreters, static
        analyses, editors, code-review applications, and more — to share
        information with each other smoothly.  '';
    homepage = "https://kythe.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.mpickering ];
  };
}
