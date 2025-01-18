{
  fetchFromGitHub,
  lib,
  runtimeShell,
  gccStdenv,
}:
gccStdenv.mkDerivation {
  pname = "up-core";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "up";
    rev = "v1.0.0";
    hash = "sha256-gLIkwNFxXkGCQiRTri0EJZSRC7xbvhUwaCmTQDqs2B8=";
  };
  installPhase = ''
    install -D up-core -t $out/bin
    mkdir -p $out/lib
    echo "#!/${runtimeShell}" > $out/lib/SOURCE_ME.sh
    $out/bin/up-core --init >> $out/lib/SOURCE_ME.sh
  '';
  shellHook = ''
    source $out/lib/SOURCE_ME.sh
  '';
  meta = {
    description = "A tool to navigate up directories more swiftly";
    longDescription = ''
      This utility allows you to move up relative directories with ease, enhancing efficiency when working in nested file systems. It simplifies navigation with fewer keystrokes.
    '';
    homepage = "https://github.com/NewDawn0/up";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platmors = lib.platforms.all;
  };
}
