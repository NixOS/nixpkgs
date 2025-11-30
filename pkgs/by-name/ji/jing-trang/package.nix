{
  lib,
  stdenv,
  fetchFromGitHub,
  jre_headless,
  jdk8_headless,
  ant,
  saxon,
}:
let
  jdk_headless = jdk8_headless; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
in
stdenv.mkDerivation rec {
  pname = "jing-trang";
  version = "20181222";

  src = fetchFromGitHub {
    owner = "relaxng";
    repo = "jing-trang";
    rev = "V${version}";
    hash = "sha256-Krupa3MGk5UaaQsaNpPMZuIUzHJytDiksz9ysCPkFS4=";
    fetchSubmodules = true;
  };

  buildInputs = [
    jdk_headless
    ant
    saxon
  ];

  CLASSPATH = "lib/saxon.jar";

  patches = [
    ./no-git-during-build.patch
  ];

  preBuild = "ant";

  installPhase = ''
    mkdir -p "$out"/{share/java,bin}
    cp ./build/*.jar ./lib/resolver.jar "$out/share/java/"

    for tool in jing trang; do
    cat > "$out/bin/$tool" <<EOF
    #! $SHELL
    export JAVA_HOME='${jre_headless}'
    exec '${jre_headless}/bin/java' -jar '$out/share/java/$tool.jar' "\$@"
    EOF
    done

    chmod +x "$out"/bin/*
  '';

  doCheck = true;
  checkPhase = "ant test";

  meta = with lib; {
    description = "RELAX NG validator in Java";
    # The homepage is www.thaiopensource.com, but it links to googlecode.com
    # for downloads and call it the "project site".
    homepage = "https://www.thaiopensource.com/relaxng/trang.html";
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    maintainers = [ maintainers.bjornfor ];
  };
}
