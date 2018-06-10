{ stdenv, curl, fetchFromGitHub, cjson, olm, luaffi }:

stdenv.mkDerivation {
  name = "weechat-matrix-bridge-2018-01-10";
  src = fetchFromGitHub {
    owner = "torhve";
    repo = "weechat-matrix-protocol-script";
    rev = "a8e4ce04665c09ee7f24d6b319cd85cfb56dfbd7";
    sha256 = "0822xcxvwanwm8qbzqhn3f1m6hhxs29pyf8lnv6v29bl8136vcq3";
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
