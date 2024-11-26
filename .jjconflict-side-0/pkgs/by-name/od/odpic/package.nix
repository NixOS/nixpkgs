{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  oracle-instantclient,
  libaio,
}:

let
  version = "5.4.0";
  libPath = lib.makeLibraryPath [ oracle-instantclient.lib ];

in
stdenv.mkDerivation {
  inherit version;

  pname = "odpic";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "odpi";
    rev = "v${version}";
    sha256 = "sha256-MmzForjAgccze7VvNcN6vX4rfiy+W9eGQ2Qh49ah7Ps=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [ oracle-instantclient ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libaio ];

  dontPatchELF = true;
  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  postFixup = ''
    ${lib.optionalString (stdenv.hostPlatform.isLinux) ''
      patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary})" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    ${lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      install_name_tool -add_rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
  '';

  meta = with lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
    maintainers = with maintainers; [ mkazulak ];
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
    hydraPlatforms = [ ];
  };
}
