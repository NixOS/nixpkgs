{
  fetchFromGitHub,
  lib,
  stdenv,
  zig,
}:
stdenv.mkDerivation {
  pname = "ansi";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "ansi";
    rev = "v1.0.0";
    hash = "sha256-0ahM9eZInPNSA6K463Ul4ot2PPplBNI2ypBRwfG6Lpo=";
  };
  buildInputs = [ zig ];
  buildPhase = ''
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # On Darwin the executable needs to link to libSystem found in /usr/lib/
      export LIBRARY_PATH=/usr/lib
      export DYLD_LIBRARY_PATH=/usr/lib
    ''}
    cacheDir=$(mktemp -d)
    zig build --global-cache-dir $cacheDir
  '';
  installPhase = "install -D zig-out/bin/ansi -t $out/bin";
  meta = {
    description = "A quick reference guide for ANSI escape codes";
    longDescription = ''
      A handy cheatsheet for quickly looking up ANSI escape codes.
      Perfect for developers working with terminal color codes and text formatting.
    '';
    homepage = "https://github.com/NewDawn0/ansi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
