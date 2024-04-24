{ stdenv, lib, fetchurl }:
let
  pname = "filebrowser";
  version = "2.28.0";
  sources = {
    x86_64-linux = {
      url =
        "https://github.com/filebrowser/filebrowser/releases/download/v${version}/linux-amd64-filebrowser.tar.gz";
      hash = "sha256-GNRSiEmOfUo+I+MvEFy+Zcrcktbk3DNGR9/ElrLU3fw=";
    };
  };
in stdenv.mkDerivation rec {
  inherit pname version;

  src = let
    platform = stdenv.hostPlatform.system;
    platforms = builtins.attrNames sources;
  in if (builtins.elem platform platforms) then
    fetchurl sources."${platform}"
  else
    throw
    "Source for ${pname} unavailable for system '${platform}'";

  nativeBuildInputs = [ ];

  buildInputs = [ ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D filebrowser $out/bin/filebrowser
    runHook postInstall
  '';

  meta = {
    homepage = "https://filebrowser.org";
    description = "Web File Browser";
    license = lib.licenses.asl20;
    mainProgram = "filebrowser";
    maintainers = [ lib.maintainers.sqlazer ];
    platforms = builtins.attrNames sources;
  };
}

