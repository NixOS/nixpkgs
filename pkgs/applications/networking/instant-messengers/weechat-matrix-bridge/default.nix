{ stdenv, curl, fetchFromGitHub, cjson, olm, luaffi }:

stdenv.mkDerivation {
  name = "weechat-matrix-bridge-2017-03-28";
  src = fetchFromGitHub {
    owner = "torhve";
    repo = "weechat-matrix-protocol-script";
    rev = "0052e7275ae149dc5241226391c9b1889ecc3c6b";
    sha256 = "14x58jd44g08sfnp1gx74gq2na527v5jjpsvv1xx4b8mixwy20hi";
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

  installPhase = ''
    mkdir -p $out/{share,lib}

    cp {matrix.lua,olm.lua} $out/share
    cp ${cjson}/lib/lua/5.2/cjson.so $out/lib/cjson.so
    cp ${olm}/lib/libolm.so $out/lib/libolm.so
    cp ${luaffi}/lib/ffi.so $out/lib/ffi.so
  '';

  meta = with stdenv.lib; {
    description = "A WeeChat script in Lua that implements the matrix.org chat protocol";
    homepage = https://github.com/torhve/weechat-matrix-protocol-script;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit; # see https://github.com/torhve/weechat-matrix-protocol-script/blob/0052e7275ae149dc5241226391c9b1889ecc3c6b/matrix.lua#L53
    platforms = platforms.unix;
  };
}
