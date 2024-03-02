{
system ? builtins.currentSystem
, lib
, fetchurl
, installShellFiles
, stdenvNoCC
}:
let
  shaMap = {
    i686-linux = "1k5w027lq4vhcm7gvpm8wyak7p5bfazn9sxgqmp9x5b1ymjgrwp9";
    x86_64-linux = "04rqdm37f79car2jvy7ifzh7qx4g5flzg94m0jlz2mkd4y66ksll";
    aarch64-linux = "1h6mc0anwf4cd7xywbkslglssv3a6snmk06m8ypzmz3p1rnngy6c";
    x86_64-darwin = "1y3n6s9ljmmp64ssx937mb34lrsy7kwch6pyxnf4alaqnjq1g6sq";
    aarch64-darwin = "0gfvbw9rwqm9gnq7d67iz2h5vqmdx1r7mfbn3fg1jrd33q6pzwv5";
  };

  urlMap = {
    i686-linux = "https://github.com/NoUseFreak/projecthelper/releases/download/v0.5.1/projecthelper_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/NoUseFreak/projecthelper/releases/download/v0.5.1/projecthelper_Linux_x86_64.tar.gz";
    aarch64-linux = "https://github.com/NoUseFreak/projecthelper/releases/download/v0.5.1/projecthelper_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/NoUseFreak/projecthelper/releases/download/v0.5.1/projecthelper_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/NoUseFreak/projecthelper/releases/download/v0.5.1/projecthelper_Darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "projecthelper";
  version = "0.5.1";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./projecthelper $out/bin/projecthelper
    installManPage ./manpages/projecthelper.1.gz
  '';

  system = system;

  meta = {
    description = "Project helper tries to save time";
    homepage = "https://github.com/nousefreak/projecthelper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NoUseFreak ];


    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}

