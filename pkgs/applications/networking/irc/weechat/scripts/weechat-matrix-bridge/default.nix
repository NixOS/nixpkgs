{ stdenv, curl, fetchFromGitHub, cjson, olm, luaffi }:

stdenv.mkDerivation {
  name = "weechat-matrix-bridge-2018-05-29";
  src = fetchFromGitHub {
    owner = "torhve";
    repo = "weechat-matrix-protocol-script";
    rev = "ace3fefc0e35a627f8a528032df2e3111e41eb1b";
    sha256 = "1snf8vn5n9wzrnqnvdrcli4199s5p114jbjlgrj5c27i53173wqw";
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
