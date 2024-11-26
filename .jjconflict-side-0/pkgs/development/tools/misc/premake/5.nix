{
  lib,
  stdenv,
  fetchFromGitHub,
  libuuid,
  cacert,
  Foundation,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "premake5";
  version = "5.0.0-beta2";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${version}";
    sha256 = "sha256-2R5gq4jaQsp8Ny1oGuIYkef0kn2UG9jMf20vq0714oY=";
  };

  buildInputs =
    [ libuuid ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Foundation
      readline
    ];

  patches = [ ./no-curl-ca.patch ];
  postPatch =
    ''
      substituteInPlace contrib/curl/premake5.lua \
        --replace "ca = nil" "ca = '${cacert}/etc/ssl/certs/ca-bundle.crt'"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace premake5.lua \
        --replace -mmacosx-version-min=10.4 -mmacosx-version-min=10.5 \
        --replace-fail '"-arch arm64"' '""' \
        --replace-fail '"-arch x86_64"' '""'
    ''
    + lib.optionalString stdenv.hostPlatform.isStatic ''
      substituteInPlace \
        binmodules/example/premake5.lua \
        binmodules/luasocket/premake5.lua \
        --replace SharedLib StaticLib
    '';

  buildPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        make -f Bootstrap.mak osx
      ''
    else
      ''
        make -f Bootstrap.mak linux
      '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://premake.github.io";
    description = "Simple build configuration and project generation tool using lua";
    mainProgram = "premake5";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
