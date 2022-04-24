{ lib, stdenv, curl, fetchFromGitHub, cjson, olm, luaffi }:

stdenv.mkDerivation {
  pname = "weechat-matrix-bridge";
  version = "unstable-2018-11-19";
  src = fetchFromGitHub {
    owner = "torhve";
    repo = "weechat-matrix-protocol-script";
    rev = "8d32e90d864a8f3f09ecc2857cd5dd6e39a8c3f7";
    sha256 = "0qqd6qmkrdc0r3rnl53c3yp93fbcz7d3mdw3vq5gmdqxyym4s9lj";
  };

  patches = [
    ./library-path.patch
  ];

  buildInputs = [ curl cjson olm luaffi ];

  postPatch = ''
    substituteInPlace matrix.lua \
      --replace "/usr/bin/curl" "${curl}/bin/curl" \
      --replace "__NIX_LIB_PATH__" "$out/lib/?.so" \
      --replace "__NIX_OLM_PATH__" "$out/share/?.lua"

    substituteInPlace olm.lua \
      --replace "__NIX_LIB_PATH__" "$out/lib/?.so"
  '';

  passthru.scripts = [ "matrix.lua" ];

  installPhase = ''
    mkdir -p $out/{share,lib}

    cp {matrix.lua,olm.lua} $out/share
    cp ${cjson}/lib/lua/${cjson.lua.luaversion}/cjson.so $out/lib/cjson.so
    cp ${olm}/lib/libolm.so $out/lib/libolm.so
    cp ${luaffi}/lib/lua/${luaffi.lua.luaversion}/ffi.so $out/lib/ffi.so
  '';

  meta = with lib; {
    description = "A WeeChat script in Lua that implements the matrix.org chat protocol";
    homepage = "https://github.com/torhve/weechat-matrix-protocol-script";
    maintainers = with maintainers; [ ];
    license = licenses.mit; # see https://github.com/torhve/weechat-matrix-protocol-script/blob/0052e7275ae149dc5241226391c9b1889ecc3c6b/matrix.lua#L53
    platforms = platforms.unix;

    # As of 2019-06-30, all of the dependencies are available on macOS but the
    # package itself does not build.
    broken = stdenv.isDarwin;
  };
}
