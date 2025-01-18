{
  fetchFromGitHub,
  fzf,
  lib,
  runtimeShell,
  rustPlatform,
  stdenv,
}:
let
  version = "1.0.0";
  meta = {
    description = "A fast directory navigation tool with a quicklist";
    longDescription = ''
      This utility allows you to change directories quickly using a user defined list of frequently used paths.
      It reduces the time spent on navigation and enhances workflow efficiency.
    '';
    homepage = "https://github.com/NewDawn0/dirStack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
  pkg = rustPlatform.buildRustPackage {
    inherit meta version;
    pname = "dirStack";
    src = fetchFromGitHub {
      owner = "NewDawn0";
      repo = "dirStack";
      rev = "v1.0.0";
      hash = "sha256-TeHldruUsG49o0tXm26prSmGTmBiRRkL7q7VZghrsXM=";
    };
    cargoHash = "sha256-ismRyvNGqWkACVwz7+2EFh114DevtwWGtdbB/w4Yqz8=";
    propagatedBuildInputs = [ fzf ];
  };
in
stdenv.mkDerivation {
  inherit meta version;
  pname = "dirStack-wrapped";
  src = null;
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    install -D ${pkg}/bin/dirStack -t $out/bin
    mkdir -p $out/lib
    echo "#!/${runtimeShell}" > $out/lib/SOURCE_ME.sh
    $out/bin/dirStack --init >> $out/lib/SOURCE_ME.sh
  '';
  shellHook = ''
    source $out/lib/SOURCE_ME.sh
  '';
}
